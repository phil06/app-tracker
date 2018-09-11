//
//  StaticCommonData.swift
//  TRACKER
//
//  Created by NHNEnt on 2018. 8. 7..
//  Copyright © 2018년 OnlyNew. All rights reserved.
//

//진짜 상수성인거만 남기고.. struct 나.. vo 로....

import UIKit

var ALL_INSTRUMENT = ["PIANO" : InstrumentType(type: InstrumentKind(name:"PIANO")!, fileListIcon: "icon_instrument_piano_30x", typeIcon: "icon_instrument_piano"),
                      "GUITAR" : InstrumentType(type: InstrumentKind(name:"GUITAR")!, fileListIcon: "icon_instrument_piano_30x", typeIcon: "icon_instrument_piano"),
                      "DRUM" : InstrumentType(type: InstrumentKind(name:"DRUM")!, fileListIcon: "icon_instrument_drum_30x", typeIcon: "icon_instrument_drum")]


func getInstrumentByIdx(idx: Int) -> String {
    switch idx {
    case 0:
        return "PIANO"
    case 1:
        return "GUITAR"
    case 2:
        return "DRUM"
    default:
        return ""
    }
}


struct InstrumentType {
    let type: InstrumentKind
    let fileListIcon: String
    let typeIcon: String
    
    var cols: Int
    var rows: Int
    
    var key1Size: Int
    var key2Size: Int
    var gridSize: Float
    
    var totOctave: Int
    
    var margin: Int
    var headerWidth: Int
    
    func getHeight() -> Int {
        //사이즈 * 음계내 건반수 * 옥타브 수
        switch type {
        case InstrumentKind.PIANO:
            return (key1Size * 5 * totOctave) + (key2Size * 7 * totOctave)
        case InstrumentKind.DRUM:
            return key1Size * rows
        default:
            return 0
        }
        
    }
    
    func getWidth() -> Int {
        return cols * key2Size
    }
    
    func getHeaderWidth() -> CGFloat {
        switch type {
        case InstrumentKind.PIANO:
            return CGFloat((headerWidth / 2) + margin)
        case InstrumentKind.DRUM:
            return CGFloat(headerWidth)
        default:
            return 0
        }
        
    }
    
    init(type: InstrumentKind, fileListIcon: String, typeIcon: String) {
        self.type = type
        self.fileListIcon = fileListIcon
        self.typeIcon = typeIcon
        self.cols = 900 //MARK: 수정할수있게 바꾸기
        
        switch type {
        case InstrumentKind.PIANO:
            cols = 900
            rows = 84
            key1Size = 10
            key2Size = 20
            totOctave = 7
            margin = 30
            headerWidth = 60
            gridSize = 20
        case InstrumentKind.DRUM:
            cols = 900
            rows = 10
            key1Size = 25
            key2Size = 25
            totOctave = 1
            margin = 30
            headerWidth = 25
            gridSize = 25
        default:
            cols = 0
            rows = 0
            key1Size = 0
            key2Size = 0
            totOctave = 0
            margin = 0
            headerWidth = 0
            gridSize = 0
        }
    }

}


enum InstrumentKind: String {
    case PIANO = "PIANO"
    case GUITAR = "GUITAR"
    case DRUM = "DRUM"
    
    init?(name: String) {
        switch name {
        case "PIANO":
            self = .PIANO
        case "GUITAR":
            self = .GUITAR
        case "DRUM":
            self = .DRUM
        default:
            return nil
        }
    }

}




let TYPE_PIANO_NOTE_SCALE_HEIGHT = [20, 10, 20, 10, 20, 20, 10, 20, 10, 20, 10, 20]
let TYPE_PIANO_NOTE_SCALE_HEIGHT_REVERSED = [20, 10, 20, 10, 20, 10, 20, 20, 10, 20, 10, 20]

let TYPE_PIANO_NOTE_BLACK_SCALE_HEIGHT = [15, 20, 10, 20, 15, 15, 20, 10, 20, 10, 20, 15]
let TYPE_PIANO_NOTE_WHITE_SCALE_HEIGHT = [25, 30, 25, 25, 30, 30, 25]

let TYPE_PIANO_NOTE_SCALE_TEXT = ["C", "D", "E", "F", "G", "A", "B"]


let TYPE_DRUM_NOTE_ICON = ["1_snare", "2_open-hi-hat", "3_close-hi-hat", "4_bass", "5_tom_hi", "6_tom_mi", "7_tom_lo", "8_floor-tom", "9_crash-cymbal", "10_ride-cymbal"]



//탭바 아이콘
enum TabBarImage: String {
    case TAB_BAR_ITEM_HOME_IMG = "icon_info"
    case TAB_BAR_ITEM_NEW_IMG = "icon_new_add"
    case TAB_BAR_ITEM_LIST_IMG = "icon_list"
}



