//
//  LiveSettings.swift
//  LiveAppSnippet
//
//  Created by ddup on 2024/11/27.
//

import Foundation

/// 引擎音频配置
struct AudioSetting {
    var audioBitrate: Int = 0 // 音频码率
    var streamModeL3: Bool = false // 是否开启L3拉流(Low-Latency Live)
}
