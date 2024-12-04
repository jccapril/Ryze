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
}
