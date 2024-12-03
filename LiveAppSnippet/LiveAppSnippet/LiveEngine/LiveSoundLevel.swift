//
//  LiveSoundLevel.swift
//  LiveAppSnippet
//
//  Created by ddup on 2024/11/26.
//

import Foundation

@objcMembers
public class LiveSoundLevel: NSObject  {
    public var streamID: String = ""
    public var soundLevel: Float = 0
    public var vad: Int32 = 0
    
    public init(streamID: String, soundlevel: Float, vad: Int32) {
        self.streamID = streamID
        self.soundLevel = soundlevel
        self.vad = vad
    }
}
