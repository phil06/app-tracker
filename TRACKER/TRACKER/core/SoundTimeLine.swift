//
//  SoundTimeLine.swift
//  TRACKER
//
//  Created by NHNEnt on 2018. 8. 21..
//  Copyright © 2018년 OnlyNew. All rights reserved.
//

import UIKit

class SoundTimeLine {
    
    var soundDic:[Int:[AudioKit]] = [Int:[AudioKit]]()
    var instrumentCol: Int!
    var bit: Double!
    var startPoint: Float!
    
    init(type: InstrumentKind) {

        //MARK: 일단은 피아노 나중에 type 에 따라
        switch type {
        case InstrumentKind.PIANO:
            instrumentCol = TYPE_PIANO.cols.rawValue
        default:
            instrumentCol = TYPE_PIANO.cols.rawValue
        }
    }
    
    func buildSoundArray(size: Int, notes: [Int:String], bit: Double, startPoint: Float) {
        
        soundDic.removeAll()
        
        self.bit = bit
        self.startPoint = startPoint
        
        notes.forEach { (key, value) in
            
            let audio = AudioKit()
            let colIdx: Int = key % instrumentCol
            
            if colIdx >= Int(startPoint) {

                audio.initWithFileName(name: value, atTime: Double(Float(colIdx) - self.startPoint) * self.bit)
                
                if var originArr = soundDic[colIdx] {
                    originArr.append(audio)
                    soundDic[colIdx] = originArr
                } else {
                    soundDic[colIdx] = [audio]
                }
            }

        }
    }

    func playSounds(sliderSync: (_ pos: Float, _ bit: Double, _ bitDelay: Double, _ startPoint: Int) -> Void) {
        //MARK: 애니메이션과 사운드 실행을 완벽하게 동기화 할 수 있는 방법이...
        if soundDic.count <= 0 {
            print("코드가 없어!")
            return
        }
        
        let sortedKeys = soundDic.keys.sorted()
        
        let startPoint = sortedKeys.first
        let endPoint = sortedKeys.last

        let startTime = soundDic.first?.value.first?.getCurrentTime()

        let duration = Double(sortedKeys.count) * self.bit
        sliderSync(Float(endPoint!), duration, self.bit, startPoint!)
        
        for idx in sortedKeys {
            for(_, obj) in (soundDic[idx]?.enumerated())! {
                obj.play(fixed: startTime!)
            }
        }
    }
    
    func stop(curPos: Int) {
        let sortedKeys = soundDic.keys.sorted()
        
        for idx in sortedKeys {

            if idx >= curPos {
                for(_, obj) in (soundDic[idx]?.enumerated())! {
                    obj.stop()
                }
            }
        }
        
        soundDic.removeAll()
    }
    
    func isPlaying() -> Bool {
        return soundDic.count > 1
    }

}
