//
//  File.swift
//  Ryze
//
//  Created by Jiang Chencheng on 2024/12/4.
//

import ShellOut

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
    
    
    init(scheme: String, workspace: String, configuration: Configuration, archivePath: String, exportPath: String, exportOptionsPlist: String) {
        self.scheme = scheme
        self.workspace = workspace
        self.configuration = configuration
        self.archivePath = archivePath
        self.exportPath = exportPath
        self.exportOptionsPlist = exportOptionsPlist
    }
}

// MARK: - Internal
extension IPATool {
    
    func build() throws{
        try clean()
        try archive()
        try export()
    }
    
    func uploadPGY() throws {
        
    }
    
}

// MARK: - Private
private extension IPATool {
    
    func clean() throws {
        print("=========== xcodebuild Clean Begin ===========".green)
        try shellOut(to: .xcodebuildClean(workspace: workspace, scheme: scheme, configuration: configuration))
        print("=========== xcodebuild Clean Success ===========".green)
    }
    
    func archive() throws{
        print("=========== xcodebuild Archive Begin ===========".green)
        try shellOut(to: .xcodebuildArchive(workspace: workspace, scheme: scheme, configuration: configuration, archivePath: archivePath))
        print("=========== xcodebuild Archive Success ===========".green)
    }
    
    func export() throws{
        print("=========== xcodebuild Export IPA Begin ===========".green)
        try shellOut(to: .xcodebuildExportArchive(archivePath: archivePath, configuration: configuration, exportPath: exportPath, exportOptionsPlist: exportOptionsPlist))
        print("=========== xcodebuild Export IPA Success ===========".green)
    }
    
}
