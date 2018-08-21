//
//  SoundTimeLine.swift
//  TRACKER
//
//  Created by NHNEnt on 2018. 8. 21..
//  Copyright © 2018년 OnlyNew. All rights reserved.
//

import Foundation

class SoundTimeLine {
    
    var soundDic:[Int:[AudioKit]] = [Int:[AudioKit]]()
    var instrumentCol: Int!
    
    init(type: InstrumentKind) {
        print("SoundTimeLine... init with \(type.rawValue)")
        
        //MARK: 일단은 피아노 나중에 type 에 따라
        switch type {
        case InstrumentKind.PIANO:
            instrumentCol = TYPE_PIANO.cols.rawValue
        default:
            instrumentCol = TYPE_PIANO.cols.rawValue
        }
    }
    
    func buildSoundArray(size: Int, notes: [Int:String]) {
        notes.forEach { (key, value) in
            let audio = AudioKit()
            let colIdx: Int = key % instrumentCol 
            
            audio.initWithFileName(name: value, atTime: Double(colIdx))
            
            if var originArr = soundDic[colIdx] {
                originArr.append(audio)
                soundDic[colIdx] = originArr
            } else {
                soundDic[colIdx] = [audio]
            }
        }
    }
    
    func playSounds() {
        
    }

}
