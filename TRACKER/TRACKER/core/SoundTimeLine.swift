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
        print("SoundTimeLine... init with \(type.rawValue)")
        
        //MARK: 일단은 피아노 나중에 type 에 따라
        switch type {
        case InstrumentKind.PIANO:
            instrumentCol = TYPE_PIANO.cols.rawValue
        default:
            instrumentCol = TYPE_PIANO.cols.rawValue
        }
    }
    
//    func buildSoundArray(size: Int, notes: [Int:String], bit: Double) {
//
//        soundDic.removeAll()
//
//        self.bit = bit
//
//        notes.forEach { (key, value) in
//            let audio = AudioKit()
//            let colIdx: Int = key % instrumentCol
//
//            print("fileName > \(value), colIdx > \(colIdx)")
//            audio.initWithFileName(name: value, atTime: Double(colIdx) * self.bit)
//
//            if var originArr = soundDic[colIdx] {
//                originArr.append(audio)
//                soundDic[colIdx] = originArr
//            } else {
//                soundDic[colIdx] = [audio]
//            }
//        }
//    }
    
    func buildSoundArray(size: Int, notes: [Int:String], bit: Double, startPoint: Float) {
        
        soundDic.removeAll()
        
        self.bit = bit
        self.startPoint = startPoint
        
        notes.forEach { (key, value) in
            
            let audio = AudioKit()
            let colIdx: Int = key % instrumentCol
            
            if colIdx >= Int(startPoint) {
                
                print("fileName > \(value), colIdx > \(colIdx)")
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
    
    
//    func playSounds() {
//        //MARK: 갯수가 많아질수록 처리시간이 늦어질텐데 앞에 시작하는 시간이랑 싱크가 안맞는 경우가 생기지 않을까..?
//        let startTime = soundDic.first?.value.first?.getCurrentTime()
//        print("기준시간 > \(String(describing: startTime?.format(using: [.year, .month, .day, .hour, .minute, .second])))")
//
//        for (_, value) in soundDic {
//            for (_, obj) in value.enumerated() {
//                obj.play(fixed: startTime!)
//            }
//        }
//
//    }
    
    func playSounds(sliderSync: (_ pos: Float, _ bit: Double, _ bitDelay: Double) -> Void) {
        
        var sortedKeys = soundDic.keys.sorted()
        
        var startPoint = sortedKeys.first
        var endPoint = sortedKeys.last
        
        print("[전체] start : \(startPoint), endPoint : \(endPoint)")
        
        let startTime = soundDic.first?.value.first?.getCurrentTime()
        print("기준시간 > \(String(describing: startTime?.format(using: [.year, .month, .day, .hour, .minute, .second])))")
        
        for idx in sortedKeys {
            print("key : \(idx)")
            sliderSync(Float(idx), self.bit, Double(Float(idx) - self.startPoint) * self.bit)
            for(_, obj) in (soundDic[idx]?.enumerated())! {
                obj.play(fixed: startTime!)
            }
        }

    }
    
    func stop() {
        soundDic.removeAll()
    }
    
    func isPlaying() -> Bool {
        return soundDic.count > 1
    }

}
