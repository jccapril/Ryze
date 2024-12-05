//
//  File.swift
//  Ryze
//
//  Created by Jiang Chencheng on 2024/12/4.
//

import Foundation
import ShellOut
import Rainbow
import Logging
import Alamofire
import PathKit


/// IPA工具
struct IPATool {

    // 项目名称
    let scheme: String
    // workspace路径
    let workspace: String
    // debug or release
    let configuration: Configuration
    // xcarchive 文件导出路径
    let archivePath: String
    // ipa导出路径
    let exportPath: String
    // exportOptionsPlist
    let exportOptionsPlist: String
    
    let apiKey: String
    
    let logger: Logger = Logger(label: "ryze-ipatool")
    
    /// IPATool
    /// - Parameters:
    ///   - scheme: 项目名
    ///   - workspace: workspace文件路径
    ///   - configuration: debug、release
    ///   - archivePath: 生成的xcarchive文件路径
    ///   - exportPath: IPA导出路径
    ///   - exportOptionsPlist: 导出参数文件路径
    init(scheme: String, workspace: String, configuration: Configuration, archivePath: String, exportPath: String, exportOptionsPlist: String, apiKey: String) {
        self.scheme = scheme
        self.workspace = workspace
        self.configuration = configuration
        self.archivePath = archivePath
        self.exportPath = exportPath
        self.exportOptionsPlist = exportOptionsPlist
        self.apiKey = apiKey
    }
}

// MARK: - Internal
extension IPATool {
    
    func build() throws{
        try clean()
        try archive()
        try export()
    }
    
    func uploadPGY() async throws {
    
        logger.info("正在获取PGYER COSToKen")
        let token = try await getPGYERCOSToken()
        logger.info("获取PGYER COSToKen成功")
        
        logger.info("ipa 正在上传PGYER")
        try await uploadPGYER(token: token)
        logger.info("ipa 上传PGYER 成功")
    
        logger.info("正在获取ipa信息")
        // 休眠3秒再去获取，以防获取不成功
        try await Task.sleep(for: .seconds(3))
        // 方法内部惠重试3次
        guard let buildInfo = try await getPGYERBuildInfo(key: token.key) else {
            return
        }
        logger.info("获取ipa信息成功 qrcode:\(buildInfo.buildQRCodeURL)")
        
    }
    
    func deleteTempFiles() throws {
        try Path(archivePath).delete()
        try Path(exportPath).delete()
    }
}

// MARK: - Private
private extension IPATool {
    
    func clean() throws {
        
        logger.info("xcodebuild Clean Begin")
        try shellOut(to: .xcodebuildClean(workspace: workspace, scheme: scheme, configuration: configuration))
        logger.info("xcodebuild Clean Success")
    }
    
    func archive() throws{
        logger.info("xcodebuild Archive Begin")
        try shellOut(to: .xcodebuildArchive(workspace: workspace, scheme: scheme, configuration: configuration, archivePath: archivePath))
        logger.info("xcodebuild Archive Success")
    }
    
    func export() throws{
        logger.info("xcodebuild Export IPA Begin")
        try shellOut(to: .xcodebuildExportArchive(archivePath: archivePath, configuration: configuration, exportPath: exportPath, exportOptionsPlist: exportOptionsPlist))
        logger.info("xcodebuild Export IPA Success")
    }
    
    func getPGYERCOSToken() async throws -> PGYToken{
        let response = try await AF.request("https://www.pgyer.com/apiv2/app/getCOSToken", method: .post, parameters: ["_api_key": apiKey, "buildType": "ios"])
            .serializingDecodable(PGYResponseData<PGYToken>.self)
            .value
        guard let data = response.data else {
            throw IPAToolError.uploadFailure(response.message)
        }
        return data
    }
    
    func uploadPGYER(token: PGYToken) async throws {
        let ipaPath = "\(exportPath)/\(scheme).ipa"
        let url = token.endpoint
        let key = token.key
        let signature = token.params.signature
        let xCosSecurityToken = token.params.xCosSecurityToken
        let _ = try await AF.upload(multipartFormData: { data in
            data.append(key.data(using: .utf8)!, withName: "key")
            data.append(signature.data(using: .utf8)!, withName: "signature")
            data.append(xCosSecurityToken.data(using: .utf8)!, withName: "x-cos-security-token")
            data.append(URL(fileURLWithPath: ipaPath), withName: "file")
        }, to: url).uploadProgress { progress in
            logger.info("上传进度: \(progress.fractionCompleted)")
        }
        .serializingDecodable(Empty.self, emptyResponseCodes: [204])
        .value
    }
    
    /// 获取 PGYER BuildInfo
    /// - Parameters:
    ///   - key: CosToken接口返回的key
    ///   - retryTime: 重试次数
    /// - Returns: PGYER BuildInfo
    func getPGYERBuildInfo(key: String, retryTime: Int = 0) async throws -> PGYBuildInfo?{
        let response = try await AF.request("https://www.pgyer.com/apiv2/app/buildInfo", method: .get, parameters: ["_api_key": apiKey, "buildKey": key], encoding: URLEncoding.queryString)
            .onHTTPResponse(perform: { response in
                logger.debug("\(response)")
            })
            .serializingDecodable(PGYResponseData<PGYBuildInfo>.self)
            .value
        
        guard let data = response.data else {
            logger.error("\(response.message)")
            if retryTime > 2 {
                return nil
            }else {
                try await Task.sleep(for: .seconds(3))
                return try await getPGYERBuildInfo(key: key, retryTime: retryTime + 1)
            }
        }
        return data
    }
}

enum IPAToolError: Error {
    case uploadFailure(_ message: String)
    
    var description: String {
        switch self {
        case .uploadFailure(let message):
            "上传失败 \(message)"
        }
    
    }
}
