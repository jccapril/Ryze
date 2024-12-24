//
//  Brew.swift
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

struct Brew: ParsableCommand {
    
    
    @Flag(name: .customLong("uninstall"), help: "是否卸载")
    var isUninstall = false
    
    static var configuration: CommandConfiguration {
        CommandConfiguration(
            abstract: "Homebrew"
        )
    }
    
    @UnDecodable
    var logger: Logger = Logger(label: "homebrew")
    
    mutating func run() throws {
        
        Figlet.say("Homebrew")
        
        if isUninstall {
            
            uninstallBrew()
            
            return
        }
        
        print("[▸] 正在检测执行环境...".yellow)
        do {
            let version = try shellOut(to: .brewVersion())
            print("[✔️] Homebrew: \(version)".green)
        } catch {
            installBrew()
        }
    }
    
    func installBrew() {
        print("[▸] 开始安装 Homebrew".yellow)
        do {
            try shellOut(to: .installBrew())
            let version = try shellOut(to: .brewVersion())
            print("[✔️] Homebrew : \(version)".green)
        } catch {
            print("[❌] Homebrew 安装失败".red)
        }
    }
    
    func uninstallBrew() {
        print("[▸] 开始卸载Homebrew".yellow)
        do {
            try shellOut(to: .uninstallBrew())
            print("[✔️] Homebrew已卸载".green)
        } catch {
            print("[❌] Homebrew卸载失败".red)
        }
    }
    
}
