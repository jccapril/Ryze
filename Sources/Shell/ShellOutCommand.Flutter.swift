//
//  ShellOutCommand.Flutter.swift
//  Ryze
//
//  Created by Jiang Chencheng on 2024/12/19.
//

import ShellOut

extension ShellOutCommand {
    /// 查看 Flutter 版本
    static func flutterVersion() -> ShellOutCommand {
        return ShellOutCommand(string: "flutter --version")
    }
    
    /// 安装 Flutter
    static func installFlutter() -> ShellOutCommand {
        return ShellOutCommand(string: "/bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"")
    }
    
    /// 卸载 Flutter
    static func uninstallFlutter() -> ShellOutCommand {
        return ShellOutCommand(string: "/bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)\"")
    }
}


