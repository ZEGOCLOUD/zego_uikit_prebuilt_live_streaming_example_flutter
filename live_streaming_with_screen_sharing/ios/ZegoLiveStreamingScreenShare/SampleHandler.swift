//
//  SampleHandler.swift
//  ZegoLiveStreamingScreenShare
//
//  Created by zego on 2023/3/1.
//

import ReplayKit
import ZegoExpressEngine

class SampleHandler: RPBroadcastSampleHandler, ZegoReplayKitExtHandler {

    override func broadcastStarted(withSetupInfo setupInfo: [String : NSObject]?) {
        // User has requested to start the broadcast. Setup info from the UI extension can be supplied but optional.
        ZegoReplayKitExt.sharedInstance().setup(withDelegate: self)
    }
    
    override func broadcastPaused() {
        // User has requested to pause the broadcast. Samples will stop being delivered.
    }
    
    override func broadcastResumed() {
        // User has requested to resume the broadcast. Samples delivery will resume.
    }
    
    override func broadcastFinished() {
        // User has requested to finish the broadcast.
        ZegoReplayKitExt.sharedInstance().finished()
    }
    
    override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
        
        ZegoReplayKitExt.sharedInstance().send(sampleBuffer, with: sampleBufferType)
        
        switch sampleBufferType {
        case RPSampleBufferType.video:
            // Handle video sample buffer
            break
        case RPSampleBufferType.audioApp:
            // Handle audio sample buffer for app audio
            break
        case RPSampleBufferType.audioMic:
            // Handle audio sample buffer for mic audio
            break
        @unknown default:
            // Handle other sample buffer types
            fatalError("Unknown type of sample buffer")
        }
    }
}
