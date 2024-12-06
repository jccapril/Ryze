//
//  Path.XcodeProj.swift
//  Ryze
//
//  Created by Jiang Chencheng on 2024/12/6.
//

import PathKit

extension Path {
    /// 是否是 XcodeProj 文件
    var isXcodeProj: Bool {
        self.extension == "xcodeproj"
    }
    
    /// 是否是 XcodeProj 文件
    var isXcWorkspace: Bool {
        self.extension == "xcworkspace"
    }
}


extension Path {
    /// 是否是 swift 文件
    var isSwift: Bool {
        self.extension == "swift"
    }
    
    var isObjc: Bool {
        self.extension == "h" || self.extension == "m"
    }
    
}


extension Path {
    
    
    /// 查询当前目录下的xcodeproj文件]
    /// - Returns: 文件路径对象
    func findXcodeProjPath() throws -> Path? {
        
        let result = try children().first { innerPath in
            innerPath.isXcodeProj
        }
        return result
    }
    
    
    /// 查询当前目录下的xcworkspace文件
    /// - Returns: 文件路径对象
    func findXcWorkspacePath() throws -> Path? {

        let result = try children().first { innerPath in
            innerPath.isXcWorkspace
        }
        return result
    }
    
    /// 重命名文件前缀
    /// - Parameters:
    ///   - prefix: 原前缀
    ///   - mixupedPrefix: 混淆后前缀
    func renamePrefix(of prefix: String, with mixupedPrefix: String) throws {
        let lastComponent = lastComponent
        let mixupedLastComponent = lastComponent.replacingOccurrences(of: prefix, with: mixupedPrefix)
        print(">>> 重命名: \(lastComponent) ---> \(mixupedLastComponent)")
        let mixupedPath = parent() + mixupedLastComponent
        try move(mixupedPath)
    }
}
