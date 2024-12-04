//
//  ShellOutCommand.xcodebuild.swift
//  Ryze
//
//  Created by Jiang Chencheng on 2024/12/4.
//

import ShellOut


enum Configuration: String {
    case debug = "Debug"
    case release = "Release"
}

extension ShellOutCommand {
        
    /// Clean
    static func xcodebuildClean(workspace: String, scheme: String, configuration: Configuration) -> ShellOutCommand {
        return ShellOutCommand(string: "xcodebuild clean -workspace \(workspace) -scheme \(scheme) -configuration \(configuration.rawValue) -quiet")
    }
    
    /// Archive
    static func xcodebuildArchive(workspace: String, scheme: String, configuration: Configuration, archivePath: String) -> ShellOutCommand {
        return ShellOutCommand(string: "xcodebuild archive -workspace \(workspace) -scheme \(scheme) -configuration \(configuration.rawValue) -archivePath \(archivePath) -quiet")
    }
    
    /// exportArchive
    static func xcodebuildExportArchive(archivePath: String, configuration: Configuration, exportPath: String, exportOptionsPlist: String) -> ShellOutCommand {
        return ShellOutCommand(string: "xcodebuild -exportArchive -archivePath \(archivePath) -configuration \(configuration.rawValue) -exportPath \(exportPath) -exportOptionsPlist \(exportOptionsPlist) -quiet")
    }
    
}
