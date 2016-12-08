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
        self.playAudio()
    }
    
    func stopBackgroundTask() {
        self.player.stop()
        print("Stop the back music")
    }
    
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
			print("hello")
        }
    }
}
