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
    
    func audioTest() {
        do {
            if let fileURL = Bundle.main.path(forResource: "065-F6", ofType: "wav") {
                print("Continue processing")
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: fileURL))
            } else {
                print("Error: No file with specified name exists")
            }
        } catch let error {
            print("Can't play the audio file failed with an error \(error.localizedDescription)")
        }
        
        audioPlayer?.numberOfLoops = 1
        audioPlayer?.play()
    }
    
  
    
}
