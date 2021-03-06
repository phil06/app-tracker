//
//  AudioKit.swift
//  TRACKER
//
//  Created by NHNEnt on 2018. 8. 21..
//  Copyright © 2018년 OnlyNew. All rights reserved.
//

import Foundation
import AVFoundation

class AudioKit {
    
    var player: AVAudioPlayer?
    var delay: TimeInterval!
    
    func initWithFileName(name: String, atTime: Double) {
        guard let path = Bundle.main.path(forResource: name, ofType: "wav") else {
            //MARK: 오류처리 어떻게..?
            print("can't find file!")
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            delay = atTime
        } catch let error {
            print("can't play sound file! > \(error.localizedDescription)")
        }
    }

    func getCurrentTime() -> TimeInterval {
        return (player?.deviceCurrentTime)!
    }
    
    func play(fixed: TimeInterval) {
        print("실행시간 > \(String(describing: (fixed + delay).format(using: [.year, .month, .day, .hour, .minute, .second])))")
        player?.play(atTime: fixed + delay)
    }
    
}
