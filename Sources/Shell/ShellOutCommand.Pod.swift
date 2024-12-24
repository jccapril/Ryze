//
//  ShellOutCommand.Pod.swift
//  Ryze
//
//  Created by Jiang Chencheng on 2024/12/4.
//

import ShellOut

extension ShellOutCommand {
    /// Install And Update all CocoaPods dependencies
    static func installAndUpdateCocoaPods() -> ShellOutCommand {
        return ShellOutCommand(string: "pod install --repo-update")
    }
    
    static func podVerison() -> ShellOutCommand {
        return ShellOutCommand(string: "pod --version")
    }
}


extension ShellOutCommand {
    /// 安装 pod 工具
    static func gemInstallCocoaPods(version: String = "1.15.2") -> ShellOutCommand {
        return ShellOutCommand(string: "sudo gem install cocoapods -v\(version)")
    }
    
    /// 卸载 pod 工具
    static func gemUninstallCocoaPods(version: String = "1.15.2") -> ShellOutCommand {
        return ShellOutCommand(string: "sudo gem uninstall cocoapods -v(\(version)")
    }
    
}
