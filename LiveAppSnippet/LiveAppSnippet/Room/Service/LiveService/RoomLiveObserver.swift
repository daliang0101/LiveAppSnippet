//
//  RoomLiveObserver.swift
//  LiveAppSnippet
//
//  Created by ddup on 2024/11/28.
//

import Foundation

protocol RoomLiveObserverProtocol: AnyObject {
    func roomLiveServiceSoundLevelChanged(soundInfos: [RoomLiveSoundInfo])
    func roomLiveServiceMuteStateChanged(muute: Bool)
}

extension RoomLiveObserverProtocol {
    func roomLiveServiceSoundLevelChanged(soundInfos: [RoomLiveSoundInfo]) {}
    func roomLiveServiceMuteStateChanged(mute: Bool) {}
}
