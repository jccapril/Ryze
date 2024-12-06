//
//  File.swift
//  Ryze
//
//  Created by Jiang Chencheng on 2024/12/6.
//

import ArgumentParser
import XcodeProj
import PathKit
import Rainbow
import ShellOut
import Logging
import Figlet

struct Build: AsyncParsableCommand {
//    @Flag(name: .customLong("beta"), help: "是否Beta版本")
//    var isBeta = false
    
    static var configuration: CommandConfiguration {
        CommandConfiguration(
            abstract: "打包并上传至PGYER"
        )
    }
    
    @Option(help: "exportOptionsPlist路径，默认路径是工程一级目录")
    var exportOptionsPlist: String?
    
    @Option(help: "pgyer apikey 访问 https://www.pgyer.com/account/api 可以获取API KEY")
    var apiKey: String = "64afc04184d4e9152e4343ff67edfa27"
    
    
    var path: String = ""
    
    var name: String = ""
     
    @UnDecodable
    var logger: Logger = Logger(label: "ryze")
    
    // MARK: - validate
//    mutating func validate() throws {
//        if apiKey.isEmpty {
//            throw ValidationError("apiKey 不能为空")
//        }
//    }
    
    // MARK: - run
    mutating func run() async throws {
        
        Figlet.say("RYZE")
        
        guard let result = try findXcodeProjPath() else {
            throw ValidationError("没有找到xcodeproj文件".red)
        }
        
        name = result.lastComponentWithoutExtension
        path = result.string
        logger.info("检测到xcodeproj文件：\(path)")
        
        try shellOut(to: .gitPull())
        print(">>> git pull".green)
        
        print(">>> pod install Begin".yellow)
        try shellOut(to: .installAndUpdateCocoaPods())
        print(">>> pod install Success".green)
       
        let ipaTool = try generateIPATool()
        
        print(">>> 开始打包".yellow)
        try ipaTool.build()
        print(">>> 打包结束".green)
        
        print(">>> 开始上传PGYER".yellow)
        try await ipaTool.uploadPGY()
        print(">>> 上传PGYER成功".green)

        try ipaTool.deleteTempFiles()
        print(">>> 删除编译生成的相关文件".green)
        
        try increaseBuildNumber()
        print(">>> 增加Build号".green)
        
        try shellOut(to: .gitCommit(message: "build+1"))
        print(">>> git commit".green)
        
        try shellOut(to: .gitPush())
        print(">>> git push".green)
    }
}


extension Build {
    
    
    /// BuildNumber + 1
    func increaseBuildNumber() throws {
    
        let projectPath = Path(path)
        let xcodeProj = try XcodeProj(path: projectPath)
        for conf in xcodeProj.pbxproj.buildConfigurations where conf.buildSettings[XcodeProj.Key.buildNumber] != nil {
            guard let buildNumberString = conf.buildSettings[XcodeProj.Key.buildNumber] as? String else {
                return
            }
            if let buildNumber = Int(buildNumberString) {
                conf.buildSettings[XcodeProj.Key.buildNumber] = buildNumber + 1
            }
        }
        try xcodeProj.write(path: projectPath)
    }

    /// 查询当前目录下的xcodeproj文件
    /// - Returns: 文件路径对象
    func findXcodeProjPath() throws -> Path? {
        
        let path = Path.current
        
        let result = try path.children().first { innerPath in
            innerPath.isXcodeProj
        }
        return result
    }
    
    /// 查询当前目录下的xcworkspace文件
    /// - Returns: 文件路径对象
    func findXcWorkspacePath() throws -> Path? {
        
        let path = Path.current
        
        let result = try path.children().first { innerPath in
            innerPath.isXcWorkspace
        }
        return result
    }
    
    /// 生成IPATool
    func generateIPATool() throws -> IPATool {
        
        let currentPath = Path.current.string
        let tempBuildPath = "\(currentPath)/.build"
       
        let workspace = "\(currentPath)/\(name).xcworkspace"
        let workspacePath = Path(workspace)
        if !workspacePath.exists {
            throw ValidationError("没有找到xcworkspace文件".red)
        }
        
        let exportOptionsPlist = if let exportOptionsPlist { exportOptionsPlist }
                                    else { "\(currentPath)/ExportOptions.plist" }
        let exportOptionsPlistPath = Path(exportOptionsPlist)
        if !exportOptionsPlistPath.exists {
            throw ValidationError("没有找到exportOptionsPlist文件".red)
        }
        
        let archivePath = "\(tempBuildPath)/\(name).xcarchive"
        let exportPath = tempBuildPath
        let configuration: Configuration = .debug

        let ipaTool = IPATool(scheme: name, workspace: workspace, configuration: configuration, archivePath: archivePath, exportPath: exportPath, exportOptionsPlist: exportOptionsPlist, apiKey: apiKey)
        
        return ipaTool

    }
}
