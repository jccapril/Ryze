//
//  Check.swift
//  Ryze
//
//  Created by Jiang Chencheng on 2025/1/2.
//

import Foundation
import ArgumentParser
import Rainbow
import ShellOut
import Logging
import Figlet
import Alamofire


struct Check: AsyncParsableCommand {
    
    @Option(help: "语言包接口")
    var url: String?
    
    @Option(help: "关键字，以、分割")
    var keyword: String =  """
    Golden Flower、golden_flower、goldenflower、game、fish、wheel、poker、boracay、Patti、call、\
    avchat、chat_to、vichat、card、chat_video、chat_voic、order_income、click_to_video_chat、\
    voice_vedio_chat、last_chat、last_voice、honor_explain_rule
    """
    

    
    static var configuration: CommandConfiguration {
        CommandConfiguration(
            abstract: "检查语言包"
        )
    }
    
    // MARK: - run
    mutating func run() async throws {

        guard let url, !url.isEmpty else {
            print("url不能为空".red)
            return
        }
        
        let keywordList: [String] = keyword.components(separatedBy: "、")
        
        print("-----需要检查的关键字-----\n\(keywordList)".yellow)
        
        guard let responseData = await request(url: url) else { return }
        
        guard let result = dataToDictionary(data: responseData) else {
            print("数据解析错误，请检查url".red)
            return
        }
        
        guard let data = result["data"] as? [String: Any] else {
            print("数据解析错误，请检查url".red)
            return
        }
        
        guard let list = data["list"] as? [String: String] else {
            print("数据解析错误，请检查url".red)
            return
        }
        
        let filterList = list.compactMap { item in
            let isExist = keywordList.contains { keyword in
                return item.key.lowercased().contains(keyword.lowercased())
            }
            if isExist {
                return item
            }else {
                return nil
            }
        }
        

        if filterList.isEmpty {
            print("Success！检查通过".green)
        }else {
            print("Warning！存在风险".red)
            print("\(filterList)".red)
        }
        
        
    }
    
    func request(url: String) async -> Data? {
        
        do {
            let data = try await API.GET(url)
            return data
        } catch {
            print("\(error)".red)
            return nil
        }
    }
    

    
    func dataToDictionary(data: Data) ->[String: Any]?{
        
        do{
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            let dic = json as? [String: Any]
            return dic
        } catch {
            print("失败\(error)".red)
            return nil
        }
        
    }
}
