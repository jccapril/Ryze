//
//  Ryze.swift
//  Ryze
//
//  Created by Jiang Chencheng on 2024/12/4.
//

import ArgumentParser

@main
struct Ryze: AsyncParsableCommand {
    static var configuration: CommandConfiguration {
        CommandConfiguration(
            subcommands: [
                Build.self,
                Mixup.self
            ]
        )
    }
}
