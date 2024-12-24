//
//  Pod.swift
//  Ryze
//
//  Created by Jiang Chencheng on 2024/12/19.
//

import Foundation
import ArgumentParser
import PathKit
import Logging
import Figlet
import ShellOut
import Rainbow
import SwiftShell

struct Pod: ParsableCommand {
    
    @Option(help: "Cocoapods 版本")
    var version: String = "1.15.2"
    
    var xcodeprojVersion = "1.24.0"
    
    static var configuration: CommandConfiguration {
        CommandConfiguration(
            abstract: "Cocoapods"
        )
    }
    
    @UnDecodable
    var logger: Logger = Logger(label: "cocoapods")
    
    mutating func run() throws {
        
        Figlet.say("Cocoapods")
        print("[▸] 正在检测执行环境...".yellow)
        
        checkXcodeproj()
        
        checkCocoapods()
        
    }
    
    func checkCocoapods()  {
        
        print("[▸] 正在检测 Cocoapods 环境...".yellow)
        do {
            let version = try shellOut(to: .podVerison())
            if version != self.version {
                print("[▸] 监测到 Cocoapods：\(version)".yellow)
                print("[▸] 开始卸载 Cocoapods：\(version)".yellow)
                try shellOut(to: .gemUninstallCocoaPods(version: version))
                checkCocoapods()
            }else {
                print("[✔️] Cocoapods: \(version)".green)
            }
        } catch {
            installCocoapods()
        }
        
    }
    
    func installCocoapods()  {
        print("[▸] 开始安装 Xcodeproj".yellow)
        do {
            try shellOut(to: .gemInstallCocoaPods(version: version))
            let version = try shellOut(to: .podVerison())
            print("[✔️] Cocoapods: \(version)".green)
        } catch {
            print("[❌] Cocoapods 安装失败 \(error)".red)
        }
    }
    
    
    func checkXcodeproj()  {
        print("[▸] 正在检测 Xcodeproj 环境...".yellow)
        do {
            let xcodeprojVersion = try shellOut(to: .xocdeprojVerison())
            if xcodeprojVersion != self.xcodeprojVersion {
                print("[▸] 监测到 Xcodeproj：\(xcodeprojVersion)".yellow)
                print("[▸] 开始卸载 Xcodeproj：\(xcodeprojVersion)".yellow)
                try shellOut(to: .gemUninstallXocdeproj(version: xcodeprojVersion))
                checkXcodeproj()
            }else {
                print("[✔️] Xcodeproj: \(xcodeprojVersion)".green)
            }
        } catch {
            installXcodeproj()
        }
    }
    
    func installXcodeproj() {
        print("[▸] 开始安装 Xcodeproj".yellow)
        do {
            try shellOut(to: .gemInstallXocdeproj(version: xcodeprojVersion))
            let version = try shellOut(to: .xocdeprojVerison())
            print("[✔️] Xcodeproj: \(version)".green)
        } catch {
            print("[❌] Xcodeproj 安装失败 \(error)".red)
        }
    }
    

    
}
