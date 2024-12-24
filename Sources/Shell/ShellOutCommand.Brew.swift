//
//  ShellOutCommand.Brew.swift
//  Ryze
//
//  Created by Jiang Chencheng on 2024/12/19.
//

import ShellOut

extension ShellOutCommand {
    /// 查看Homebrew 版本
    static func brewVersion() -> ShellOutCommand {
        return ShellOutCommand(string: "brew --version")
    }
    
    /// 安装 Homebrew
    static func installBrew() -> ShellOutCommand {
        return ShellOutCommand(string: "/bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"")
    }
    
    /// 卸载 Homebrew
    static func uninstallBrew() -> ShellOutCommand {
        return ShellOutCommand(string: "/bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)\"")
    }
}


