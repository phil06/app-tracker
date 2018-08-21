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
    
    var pianoKit: AudioKitPiano?
    var pianoKit2: AudioKitPiano?
    var pianoKitArr:[AudioKitPiano] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pianoKitArr += [AudioKitPiano()]
        pianoKitArr += [AudioKitPiano()]
        pianoKitArr += [AudioKitPiano()]
        
        let startTime = pianoKitArr[0].initFileName(name: "043-G4", startTime: 0)
        pianoKitArr[0].playMedia(delay: 3.0)
        
        _ = pianoKitArr[1].initFileName(name: "065-F6", startTime: startTime)
        pianoKitArr[1].playMedia(delay: 2.0)
        
        _ = pianoKitArr[2].initFileName(name: "067-G6", startTime: startTime)
        pianoKitArr[2].playMedia(delay: 1.0)
        
        var timeline = SoundTimeLine(type: InstrumentKind.PIANO)

    }
    
}


extension TimeInterval {
    func format(using units: NSCalendar.Unit) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = units
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .pad

        return formatter.string(from: self)
    }
}
