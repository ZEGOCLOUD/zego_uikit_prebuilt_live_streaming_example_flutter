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
    
    
    func broadcastFinished(_ broadcast: ZegoReplayKitExt, reason: ZegoReplayKitExtReason) {
        switch reason {
        case .hostStop:
            let userInfo = [NSLocalizedDescriptionKey: "Host app stopped screen capture"]
            let error = NSError(domain: NSCocoaErrorDomain, code: 0, userInfo: userInfo)
            finishBroadcastWithError(error)

        case .connectFail:
            let userInfo = [NSLocalizedDescriptionKey: "Connect host app failed; need to startScreenCapture in host app"]
            let error = NSError(domain: NSCocoaErrorDomain, code: 0, userInfo: userInfo)
            finishBroadcastWithError(error)

        case .disconnect:
            let userInfo = [NSLocalizedDescriptionKey: "Disconnected from host app"]
            let error = NSError(domain: NSCocoaErrorDomain, code: 0, userInfo: userInfo)
            finishBroadcastWithError(error)

        default:
            let userInfo = [NSLocalizedDescriptionKey: "Unknown reason for broadcast finish"]
            let error = NSError(domain: NSCocoaErrorDomain, code: 0, userInfo: userInfo)
            finishBroadcastWithError(error)
        }
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
