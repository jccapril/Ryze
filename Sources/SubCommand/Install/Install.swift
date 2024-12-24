//
//  Install.swift
//  Ryze
//
//  Created by Jiang Chencheng on 2024/12/19.
//

import ArgumentParser
import PathKit
import Logging
import Figlet

struct Install: ParsableCommand {
    
    static var configuration: CommandConfiguration {
        CommandConfiguration(
            abstract: "便捷安装工具",
            subcommands: [
                Brew.self,
                Pod.self,
                Flutter.self,
            ]
        )
    }
}
