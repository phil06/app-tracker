//
//  AudioKitPiano.swift
//  TRACKER
//
//  Created by saera on 2018. 8. 19..
//  Copyright © 2018년 OnlyNew. All rights reserved.
//

import Foundation
import AVFoundation

class AudioKitPiano {
    
    var audioPlayer: AVAudioPlayer?
    var curInterval: TimeInterval!

    func initFileName(name: String, startTime: TimeInterval) -> TimeInterval {

        guard let path = Bundle.main.path(forResource: name, ofType: "wav") else {
            print("can't find file!")
            return 0
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            if startTime <= 0 {
                curInterval = audioPlayer?.deviceCurrentTime
            } else {
                curInterval = startTime
            }
        } catch let error {
            print("Can't play the audio file failed with an error \(error.localizedDescription)")
        }
        
        return curInterval
    }
    
    func playMedia(delay: TimeInterval) {
        print("기준시간 > \(String(describing: curInterval.format(using: [.year, .month, .day, .hour, .minute, .second])))")
        audioPlayer?.play(atTime: curInterval + delay)
        print("실행시간 > \(String(describing: (curInterval + delay).format(using: [.year, .month, .day, .hour, .minute, .second])))")
    }
    
    
}

