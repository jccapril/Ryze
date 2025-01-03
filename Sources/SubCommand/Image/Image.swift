//
//  Image.swift
//  Ryze
//
//  Created by Jiang Chencheng on 2024/12/20.
//

import Foundation
import ArgumentParser
import PathKit
import Logging
import Figlet
import ImageIO
import CryptoKit
import CoreGraphics


struct Image: ParsableCommand {
    static var configuration: CommandConfiguration {
        CommandConfiguration(
            abstract: "修改图片哈希值"
        )
    }
    
    
    @UnDecodable
    var logger: Logger = Logger(label: "mixup")
    
    mutating func run() throws {
        
        Figlet.say("IMAGE HASH")
        
    }
    
    // 计算数据的SHA-256哈希值
    func sha256(_ data: Data) -> String {
        let hash = SHA256.hash(data: data)
        return hash.map { String(format: "%02x", $0) }.joined()
    }
    
    // 读取图片并返回其数据
//    func imageData(for filePath: String) throws -> Data? {
//        guard let cgImageSource = CGImageSourceCreateWithURL(URL(fileURLWithPath: filePath) as CFURL, nil) else {
//            throw NSError(domain: NSCocoaErrorDomain, code: NSFileReadNoSuchFileError, userInfo: nil)
//        }
//        
//        guard let cgImage = CGImageSourceCreateImageAtIndex(cgImageSource, 0, nil) else {
//            throw NSError(domain: NSCocoaErrorDomain, code: NSFileReadCorruptFileError, userInfo: nil)
//        }
//        
//
//        if let cgContext = CGContext(data: nil, width: CGImageGetWidth(cgImage), height: CGImageGetHeight(cgImage), bitsPerComponent: CGImageGetBitsPerComponent(cgImage), bytesPerRow: 0, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) {
//            cgContext.draw(cgImage, in: CGRect(x: 0, y: 0, width: CGImageGetWidth(cgImage), height: CGImageGetHeight(cgImage)))
//            if let cgImageModified = cgContext.makeImage() {
//                return UIImage(cgImage: cgImageModified).jpegData(compressionQuality: 1.0)!
//            }
//        }
//        return nil
//    }
    
    // 修改文件夹下所有PNG图片的哈希值
//    func modifyHashes(in folderPath: String) {
//        do {
//            
//            let currentPath = Path.current
//            currentPath.forEach { path in
//                if filePath.hasSuffix(".png") {
//                    let imageData = try imageData(for: filePath)
//                    guard let data = imageData else {
//                        print("Failed to read image at path: \(filePath)")
//                        continue
//                    }
//                    
//                    let newHash = sha256(data)
//                    print("New hash for \(filePath): \(newHash)")
//                    
//                    // 这里可以选择保存修改后的图片数据回文件系统
//                    // let outputFilePath = getOutputPath(for: filePath)
//                    // try data.write(to: URL(fileURLWithPath: outputFilePath))
//                }
//            }
//        } catch {
//            print("Error processing folder: \(error.localizedDescription)")
//        }
//    }


    
}
