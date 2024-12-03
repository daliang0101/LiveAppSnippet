//
//  LiveStream.swift
//  LiveAppSnippet
//
//  Created by ddup on 2024/11/26.
//

import Foundation

//拉流线路类型
@objc public enum LiveStreamResourceMode: UInt {
    case Stream_Default = 0
    /** CDN */
    case Stream_CDN = 1
    /** L3 */
    case Stream_L3 = 2 // Low-Latency Live
    /** rtc */
    case Stream_RTC = 3
    /** CDNPlus */
    case Stream_CDN_Plus = 4
}

@objcMembers
public class LiveStream : NSObject {
    public var userID: String = ""
    public var userName: String = ""
    public var streamID: String = ""
    public var extraInfo: String = ""

    public init(userID: String, userName: String,streamID: String, extraInfo: String) {
        self.userID = userID
        self.userName = userName
        self.streamID = streamID
        self.extraInfo = extraInfo
    }
}

@objcMembers
public class LiveStreamExtraInfo: NSObject  {
    public var params: String = ""
    public var flvUrls:[String] = []
    public var rtmpUrls:[String] = []
    public var mode:LiveStreamResourceMode = .Stream_CDN
}
