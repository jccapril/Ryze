//
//  File.swift
//  Ryze
//
//  Created by Jiang Chencheng on 2024/12/6.
//

import XcodeProj

extension XcodeProj {
    
    /// build + 1
    func increaseBuildNumber() {
        for conf in self.pbxproj.buildConfigurations where conf.buildSettings[XcodeProj.Key.buildNumber] != nil {
            guard let buildNumberString = conf.buildSettings[XcodeProj.Key.buildNumber] as? String else {
                return
            }
            if let buildNumber = Int(buildNumberString) {
                conf.buildSettings[XcodeProj.Key.buildNumber] = buildNumber + 1
            }
        }
    }
    
}

extension XcodeProj {
    
    enum Key {
        static let buildNumber = "CURRENT_PROJECT_VERSION"
    }
    
}
