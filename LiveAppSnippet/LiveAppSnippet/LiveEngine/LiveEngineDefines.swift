//
//  LiveEngineDefines.swift
//  LiveAppSnippet
//
//  Created by ddup on 2024/11/26.
//

import Foundation

// 发布直播的模式
@objc public enum LiveEnginePublishFlag:Int32 {
    /**  连麦模式，直播流会推到即构服务器，然后转推到CDN，默认连麦者之间从即构服务器拉流，观众从 CDN 拉流 */
    case JOIN_PUBLISH = 0
    /**  混流模式，同连麦模式，有混流需求时使用 */
    case MIX_STREAM      = 2
    /**  单主播模式，直播流会直接推到CDN，不经过即构服务器 */
    case SINGLE_ANCHOR   = 4
}

@objc public enum LiveEngineRole: Int {

    /** 主播 */
    case anchor    = 1
    /** 观众 */
    case audiece   = 2
}

@objc public enum LiveEngineStreamNum: Int {
    /** 新增流 */
    case add    = 2001
    /** 删除流 */
    case delete = 2002
}


@objc public enum LiveEngineDeviceError: Int {
    /** 一般性错误 */
    case Generic = -1
    /** 无效设备 ID */
    case InvalidID = -2
    /** 没有权限 */
    case NoAuthoriZation = -3
    /** 采集帧率为0 */
    case ZeroFps = -4
    /** 设备被占用 */
    case InUseByOther = -5
    /** 设备未插入 */
    case Unplugged = -6
    /** 媒体服务无法恢复 */
    case MediaServicesLost = -8
    /** 设备被 Siri 占用 */
    case InUseBySiri  = -9
    /** 设备采集的声音过低 */
    case SoundLevelTooLow  = -10
    /** 可能是由 iPad 磁吸保护套引起的设备被占用问题 */
    case MagneticCase = -11
}


@objc public enum LiveEngineCodecError: Int {
    /** 成功 */
    case None       = 0
    /** 不支持 */
    case NoSupport  = -1
    /** 失败 */
    case Failed     = -2
    /** 软解性能不足 */
    case LowFps     = -3

}

// 流错误信息
@objc public enum LiveStreamErrorCode:Int32 {
    /**  */
    case kOK = 0
    /** 没有登录房间  */
    case NotLoginError   = 10000105
    /**  不存在的流 */
    case NotExistError   = 12301004
}

@objc public enum LiveEngineLiveEventCode:Int {
    /** 播放直播开始重试 */
    case  PlayBeginRetry = 1
    /** 播放直播重试成功 */
    case  PlayRetrySuccess = 2

    /** 发布直播开始重试 */
    case PublishBeginRetry = 3

    /** 发布直播重试成功 */
    case PublishRetrySuccess = 4

    /** 拉流临时中断 */
    case PlayTempDisconnected = 5

    /** 推流临时中断 */
    case PublishTempDisconnected = 6

    /** 视频卡顿开始 */
    case PlayVideoBreak = 7

    /** 视频卡顿结束 */
    case PlayVideoBreakEnd = 8

    /** 视频卡顿取消 */
    case PlayVideoBreakCancel = 13

    /** 音频卡顿开始 */
    case PlayAudioBreak = 9

    /** 音频卡顿结束 */
    case PlayAudioBreakEnd = 10

    /** 音频卡顿取消 */
    case PlayAudioBreakCancel = 14

    /** 注册推流信息失败 */
    case PublishInfoRegisterFailed = 11

    /** 注册推流信息成功 */
    case PublishInfoRegisterSuccess = 12
}

@objc public enum LiveEngineMediaRecordType: Int {
    /** 只录制音频 */
    case MEDIA_RECORD_AUDIO = 1
    /** 只录制视频 */
    case MEDIA_RECORD_VIDEO = 2
    /** 同时录制音频、视频 */
    case MEDIA_RECORD_BOTH = 3
}

@objc public enum LiveEngineMediaRecordFormat: Int {
    //    /** 录制文件为 FLV 格式 */
    case  MEDIA_RECORD_FLV  = 1
    /** 录制文件为 MP4 格式 */
    case MEDIA_RECORD_MP4  = 2
    /** 录制文件为 AAC 格式 */
    case  MEDIA_RECORD_AAC  = 4
    /** 录制文件为 M3U8 格式，不推荐使用 */
    case  MEDIA_RECORD_M3U  = 7
}

@objc public enum LiveEngineMediaRecordChannelIndex: Int {
        /** 第一路录制通道，即推流时 ZegoAPIPublishChannelIndex 选择了主推流通道，录制时采用第一路录制通道 */
    case   MEDIA_RECORD_CHN_MAIN  = 0
        /** 第二路录制通道，即推流时 ZegoAPIPublishChannelIndex 选择了第二路推流通道，录制时采用第二路录制通道 */
    case   MEDIA_RECORD_CHN_AUX = 1
        /** 第三路录制通道，即推流时 ZegoAPIPublishChannelIndex 选择了第三路推流通道，录制时采用第三路录制通道 */
    case   MEDIA_RECORD_CHN_THIRD = 2
        /** 第四路录制通道，即推流时 ZegoAPIPublishChannelIndex 选择了第四路推流通道，录制时采用第四路录制通道 */
    case   MEDIA_RECORD_CHN_FOURTH = 3
}
