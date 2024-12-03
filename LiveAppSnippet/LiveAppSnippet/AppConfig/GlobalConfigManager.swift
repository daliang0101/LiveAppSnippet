//
//  GlobalConfigManager.swift
//  LiveAppSnippet
//
//  Created by ddup on 2024/11/27.
//

import Foundation

final class GlobalConfigManager {
    
    static let shared = GlobalConfigManager()
    
    var settingConfig: SettingConfig = SettingConfig()
    
}
