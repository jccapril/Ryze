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
    
    @Option(help: "需要混淆的文件前缀")
    var prefix: String = "BT"
    
    @Option(help: "混淆后的文件前缀")
    var mixupedPrefix: String = "JL"
    
    
    @UnDecodable
    var logger: Logger = Logger(label: "mixup")
    
    /// 需要混淆的类名
    var needMixupClsList:[String] = []

    mutating func run() throws {
        
        
        Figlet.say("MIXUP")
        
        guard let result = try Path.current.findXcodeProjPath() else {
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
            needMixupClsList.append(name)
            
            // 重命名文件
            do {
                try path.renamePrefix(of: prefix, with: mixupedPrefix)
            }catch {
                logger.error("\(error)")
            }

            
        }
        
        print(">> 开始修改类名".yellow)
        currentPath.forEach { path in
            if path.isDirectory { return }
            do {
                let data = try path.read()
                guard var content = String(data: data, encoding: .utf8) else { return }
                
                needMixupClsList.forEach { cls in
                    let mixupedCls = cls.replacingOccurrences(of: prefix, with: mixupedPrefix)
                    content = content.replacingOccurrences(of: cls, with:mixupedCls)
                }
                
                try path.write(content, encoding: .utf8)
                logger.info("修改: \(path.string)")
            
            } catch {
                logger.error("\(error)")
            }
        }
        
        print(">> 混淆完成".green)
        
        
    }
    
}

