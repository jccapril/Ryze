//
//  Mixup.swift
//  Ryze
//
//  Created by Jiang Chencheng on 2024/12/6.
//

import ArgumentParser
import PathKit
import Logging
import Figlet

struct Mixup: ParsableCommand {
    
    static var configuration: CommandConfiguration {
        CommandConfiguration(
            abstract: "混淆"
        )
    }

    
    @UnDecodable
    var logger: Logger = Logger(label: "mixup")
    
    
    @Option(help: "需要混淆的前缀")
    var prefix: String = "BT"
    
    @Option(help: "混淆后的前缀")
    var mixupedPrefix: String = "JL"
    
    
    var needMixupNameList:[String] = []

    mutating func run() throws {
        
        
        Figlet.say("MIXUP")
        
        guard let result = try findXcodeProjPath() else {
            throw ValidationError("没有找到xcodeproj文件".red)
        }
        
        print(">> 开始混淆...".yellow)
        
        let name = result.lastComponentWithoutExtension
        
        let currentPath = Path.current

        let targetPath = try currentPath.children().first { innerPath in
            innerPath.lastComponent == name && innerPath.isDirectory
        }
        
        guard let targetPath else { return }
        
        print(">> 重命名文件".yellow)
        targetPath.forEach { path in
            if path.isDirectory { return }
            guard path.isObjc || path.isSwift else { return }
            let name = path.lastComponentWithoutExtension
            guard name.hasPrefix(prefix) else { return }
            
            // 需要混淆的类名
            needMixupNameList.append(name)
            
            // 重命名文件
            rename(path: path, of: prefix, with: mixupedPrefix)
            
        }
        
        print(">> 开始修改类名".yellow)
        
        currentPath.forEach { path in
            if path.isDirectory { return }
            do {
                let data = try path.read()
                guard var content = String(data: data, encoding: .utf8) else { return }
                
                needMixupNameList.forEach { cls in
                    let mixupedCls = cls.replacingOccurrences(of: prefix, with: mixupedPrefix)
                    content = content.replacingOccurrences(of: cls, with:mixupedCls)
                }
                
                try path.write(content, encoding: .utf8)
                print(">> 混淆: \(path.string)".yellow)
            
            } catch {
                logger.error("\(error)")
            }
        }
        
        print(">> 混淆成功".green)
        
        
    }
    
}

private extension Mixup {
    
    func rename(path: Path, of originPrefix: String, with mixupPrefix: String) {
        let lastComponent = path.lastComponent
        let mixupedLastComponent = lastComponent.replacingOccurrences(of: prefix, with: mixupedPrefix)
        let mixupedPath = path.parent() + mixupedLastComponent
        logger.info("重命名 \(lastComponent) --> \(mixupedLastComponent)")
        do {
            try path.move(mixupedPath)
        } catch {
            logger.error("\(error)")
        }
    }
    
    
    /// 查询当前目录下的xcodeproj文件]
    /// - Returns: 文件路径对象
    func findXcodeProjPath() throws -> Path? {
        
        let path = Path.current
        
        let result = try path.children().first { innerPath in
            innerPath.isXcodeProj
        }
        return result
    }
    
}
