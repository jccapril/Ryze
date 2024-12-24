//
//  ShellOutCommand.Xcodeporj.swift
//  Ryze
//
//  Created by Jiang Chencheng on 2024/12/19.
//

import ShellOut

extension ShellOutCommand {
    /// 安装 Xocdeproj 工具
    static func gemInstallXocdeproj(version: String = "1.24.0") -> ShellOutCommand {
        return ShellOutCommand(string: "sudo gem install xcodeproj -v\(version)")
    }
    
    /// 安装 Xocdeproj 工具
    static func gemUninstallXocdeproj(version: String = "1.24.0") -> ShellOutCommand {
        return ShellOutCommand(string: "sudo gem uninstall xcodeproj -v\(version)")
    }
}


extension ShellOutCommand {
    
    static func xocdeprojVerison() -> ShellOutCommand {
        return ShellOutCommand(string: "xcodeproj --version")
    }
    
}
