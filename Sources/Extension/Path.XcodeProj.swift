//
//  Path.XcodeProj.swift
//  Ryze
//
//  Created by Jiang Chencheng on 2024/12/6.
//

import PathKit

extension Path {
    /// 是否是 XcodeProj 文件
    var isXcodeProj: Bool {
        self.extension == "xcodeproj"
    }
    
    /// 是否是 XcodeProj 文件
    var isXcWorkspace: Bool {
        self.extension == "xcworkspace"
    }
}
