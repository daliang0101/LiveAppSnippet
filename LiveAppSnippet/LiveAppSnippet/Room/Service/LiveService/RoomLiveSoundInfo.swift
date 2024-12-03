//
//  RoomLiveSoundInfo.swift
//  LiveAppSnippet
//
//  Created by ddup on 2024/11/28.
//

import Foundation

class RoomLiveSoundInfo {
    var streamID: String = ""
    var soundLevel: Float = 0

    init(streamID: String, soundLevel: Float) {
        self.streamID = streamID
        self.soundLevel = soundLevel
    }
}
