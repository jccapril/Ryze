//
//  CheckKeyword.swift
//  Ryze
//
//  Created by Jiang Chencheng on 2025/1/10.
//

import Foundation
import ArgumentParser
import Rainbow
import ShellOut
import Logging
import Figlet
import PathKit


struct CheckKeyword: ParsableCommand {
    
    
    @Option(help: "关键字，以、分割")
    var keyword: String =  """
    chat_price、chat_money、chatPrice、chatMoney、video_price、photo_price、\
    bigwin、big_win、prize_pool、win_coin、Grand_prize、lottery、slotgame、poker、\
    alipay、bank、bank_id、wx_pay、web_pay、pay_type、\
    game、game_id、game_icon、game_list、\
    prize、money
    """
    

    
    static var configuration: CommandConfiguration {
        CommandConfiguration(
            abstract: "检查关键字"
        )
    }
    
    // MARK: - run
    mutating func run()  throws {

        
        let path = Path.current
        
        let keywordList = keyword.components(separatedBy: "、")
       
        searchFiles(in: path, keywords: keywordList)
        
    }
    
    // 递归搜索文件并查找关键字
    func searchFiles(in directory: Path, keywords: [String])  {
        // 检查目录是否存在
        guard directory.exists else {
            print("目录不存在：\(directory)")
            return
        }

        // 遍历目录及其子目录中的所有文件
        directory.forEach {
            if $0.isFile && !isWhiteList(file: $0) {
                searchKeyword(in: $0, keywords: keywords)
            }
        }
    }
    
    func isWhiteList(file: Path) -> Bool {
        let whiteList: [String] = [
            "Pods/AgoraRtcEngine_Special_iOS", "Pods/FBSDKCoreKit",
            "Pods/BTBytedEffect", "Pods/pop", "Pods/GoogleMLKit",
            "Pods/FirebaseAnalytics", "Pods/AppsFlyerFramework", "Pods/MLKitVision",
            "Pods/CocoaAsyncSocket", "Pods/Texture", "Pods/MLKitFaceDetection",
            "Pods/CocoaAsyncSocket", ".git/", "Pods/MLKitCommon",
            "Pods/FirebaseCore/"
        ]
        return whiteList.contains {
            file.string.contains($0)
        }
    }

    // 在文件中查找关键字
    func searchKeyword(in file: Path, keywords: [String]) {
        do {
            let data = try Data(contentsOf: file.url)
               if let content = String(data: data, encoding: .utf8) {
                   let lines = content.split(separator: "\n")
                   for (index, line) in lines.enumerated() {
                       keywords.forEach { keyword in
                           if line.contains(keyword) {
                               print("匹配到关键字\(keyword)\n\(file)[第\(index + 1)行]\n\(line)".red)
                           }
                       }
                   }
               } else {
//                   print("文件不是 UTF-8 文本：\(file)".blue)
               }


        } catch {
            print("无法读取文件：\(file), 错误：\(error)".red)
        }
    }

}
