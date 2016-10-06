//
//  BackgroundTask.swift
//
//  Created by Taiwen Jin on 10/03/16.
//  Copyright © 2016 Taiwen Jin. All rights reserved.
//

import AVFoundation

class BackgroundTask {
    
    var player = AVAudioPlayer()
    
    func startBackgroundTask() {
//         NotificationCenter.default.addObserver(self, selector: #selector(interuptedAudio), name: NSNotification.Name.AVAudioSessionInterruption, object: AVAudioSession.sharedInstance())
        self.playAudio()
    }
    
    func stopBackgroundTask() {
//         NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVAudioSessionInterruption, object: nil)
        self.player.stop()
        print("Stop the back music")
    }
    
//    @objc private func interuptedAudio(notification: NSNotification) {
//        if notification.name == NSNotification.Name.AVAudioSessionInterruption && notification.userInfo != nil {
//            var info = notification.userInfo!
//            var intValue = 0
//            (info[AVAudioSessionInterruptionTypeKey]! as AnyObject).getValue(&intValue)
//            if intValue == 1 {
//                playAudio()
//            }
//        }
//    }
    
    private func playAudio() {
        do {
            let bundle = Bundle.main.path(forResource: "FitExSong", ofType: "wav")
            print("check music")
            let alertSound = NSURL(fileURLWithPath: bundle!)
            print("find music link")
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with:AVAudioSessionCategoryOptions.mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
            print("set the audio session type")
            try self.player = AVAudioPlayer(contentsOf: alertSound as URL)
            self.player.numberOfLoops = -1
            self.player.volume = 0.01
            self.player.prepareToPlay()
            self.player.play()
            print("start to play")
        } catch  {
            print(error)
        }
    }
}
