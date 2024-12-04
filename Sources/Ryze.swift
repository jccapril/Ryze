//
//  Ryze.swift
//  Ryze
//
//  Created by Jiang Chencheng on 2024/12/4.
//

import Figlet
import ArgumentParser
import XcodeProj
import PathKit
import Rainbow
import ShellOut

@main
struct Ryze: ParsableCommand {
    
    @Flag(name: .customLong("beta"), help: "是否Beta版本")
    var isBeta = false
    
    @Option(help: "exportOptionsPlist路径")
    var exportOptionsPlist: String?
    
    var path: String = ""
    
    var name: String = ""
    
    @Argument(help: "项目名称")
    var argument: [String]
    
    mutating func validate() throws {
        
    }
    
    mutating func run() throws {
        
        Figlet.say("RYZE")
        
        name = argument[0]
        
        guard let result = try findXcodeProjPath() else {
            throw ValidationError("没有找到xcodeproj文件".red)
        }
        path = result.string
        print(">>> 检测到xcodeproj文件：\(path)".green)
        
        try installPod()
       
        try buildProject()
        
        // TODO: - 上传 IPA
        
        // TODO: - 删除 xcode build 生成的文件
        
        try increaseBuildNumber()
        print(">>> 增加Build号".green)
        
        // TODO: - 提交 Git
    }
    

}


extension Ryze {
    
    
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
    
    func installPod() throws {
        print("=========== pod install Begin ===========".green)
        try shellOut(to: .installAndUpdateCocoaPods())
        print("=========== pod install Success ===========".green)
    }
    
    func buildProject() throws {
        
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

        let ipaTool = IPATool(scheme: name, workspace: workspace, configuration: configuration, archivePath: archivePath, exportPath: exportPath, exportOptionsPlist: exportOptionsPlist)
        
        try ipaTool.build()
    }
}


// MARK: - XcodeProj Key
extension XcodeProj {
    
    enum Key {
        static let buildNumber = "CURRENT_PROJECT_VERSION"
    }
    
}

// MARK: - Path Extension
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
