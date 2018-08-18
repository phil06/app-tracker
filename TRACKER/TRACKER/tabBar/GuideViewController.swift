//
//  GuideViewController.swift
//  TRACKER
//
//  Created by saera on 2018. 8. 19..
//  Copyright © 2018년 OnlyNew. All rights reserved.
//

import UIKit
import AVFoundation

class GuideViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        AudioKitPiano().audioTest()
        
        playSound(name: "043-G4")
    }
    

}

extension GuideViewController: AVAudioPlayerDelegate {
    func playSound(name: String) {
        guard let path = Bundle.main.path(forResource: name, ofType: "wav") else {
            print("音源ファイルが見つかりません")
            return
        }
        
        do {
            // AVAudioPlayerのインスタンス化
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            
            // AVAudioPlayerのデリゲートをセット
            audioPlayer?.delegate = self
            
            // 音声の再生
            audioPlayer?.play()
        } catch {
        }
    }
}
