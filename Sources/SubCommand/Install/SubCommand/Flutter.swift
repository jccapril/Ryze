//
//  Flutter.swift
//  Ryze
//
//  Created by Jiang Chencheng on 2024/12/19.
//

import ArgumentParser
import PathKit
import Logging
import Figlet
import ShellOut
import Rainbow

struct Flutter: ParsableCommand {
    
    
    @Flag(name: .customLong("uninstall"), help: "是否卸载")
    var isUninstall = false
    
    static var configuration: CommandConfiguration {
        CommandConfiguration(
            abstract: "Flutter"
        )
    }
    
    @UnDecodable
    var logger: Logger = Logger(label: "flutter")
    
    mutating func run() throws {
        
        Figlet.say("Flutter")
        
        if isUninstall {
//            uninstallFlutter()
            print("[❌] Flutter 卸载失败".red)
            return
        }
        
        
        print("[▸] 正在检测执行环境...".yellow)
        do {
            let version = try shellOut(to: .flutterVersion())
            print("[✔️] Flutter: \(version)".green)
        } catch {
            installFlutter()
        }
    }
    
    func installFlutter() {
        print("[▸] 开始安装 Flutter".yellow)
        do {
//            try shellOut(to: .installBrew())
            let version = try shellOut(to: .flutterVersion())
            print("[✔️] Flutter: \(version)".green)
        } catch {
            print("[❌] Flutter 安装失败".red)
        }
    }
    
//    func uninstallFlutter() {
//        print("[▸] 开始卸载 Flutter ".yellow)
//        do {
////            try shellOut(to: .uninstallBrew())
//            print("[✔️] Flutter 已卸载".green)
//        } catch {
//            print("[❌] Flutter 卸载失败".red)
//        }
//    }
    
}
