//
//  StaticCommonData.swift
//  TRACKER
//
//  Created by NHNEnt on 2018. 8. 7..
//  Copyright © 2018년 OnlyNew. All rights reserved.
//

//진짜 상수성인거만 남기고.. struct 나.. vo 로....

import UIKit

let ALL_INSTRUMENT = [InstrumentType(type: InstrumentKind(code:0)!),
                      InstrumentType(type: InstrumentKind(code:1)!),
                      InstrumentType(type: InstrumentKind(code:2)!)]

struct InstrumentType {
    let type: InstrumentKind
    
}



//MARK: 악기 선택 아이콘

enum InstrumentKind: String {
    case PIANO = "PIANO"
    case GUITAR = "GUITAR"
    case DRUM = "DRUM"
    
    var getIcon: String {
        switch self {
        case .PIANO:
            return "icon_instrument_piano_30x"
        case .GUITAR:
            return "icon_new_add"
        case .DRUM:
            return "icon_instrument_drum_30x"
        }
    }
    
    var getMenuIcon: String {
        switch self {
        case .PIANO:
            return "icon_instrument_piano"
        case .GUITAR:
            return "icon_instrument_piano"
        case .DRUM:
            return "icon_instrument_drum"
        }
    }
    
    init?(code: Int) {
        switch code {
        case 0:
            self = .PIANO
        case 1:
            self = .GUITAR
        case 2:
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


enum TYPE_PIANO: Int {
    case BLACKKEY_SIZE = 10
    case WHITEKEY_SIZE = 20
    case cols =  900 //임시 정한건 없음
    case rows = 84
    case totOctave = 7
    
    static let getHeight: Int = {
        //사이즈 * 음계내 건반수 * 옥타브 수
        return (BLACKKEY_SIZE.rawValue * 5 * totOctave.rawValue) + (WHITEKEY_SIZE.rawValue * 7 * totOctave.rawValue)
    }()
    
    static let getWidth: Int = {
        return cols.rawValue * WHITEKEY_SIZE.rawValue
    }()

}



//탭바 아이콘
enum TabBarImage: String {
    case TAB_BAR_ITEM_HOME_IMG = "icon_info"
    case TAB_BAR_ITEM_NEW_IMG = "icon_new_add"
    case TAB_BAR_ITEM_LIST_IMG = "icon_list"
}

//추가 화면
let ADD_GRID_LEFT_HEADER_WIDTH: CGFloat = 60
let ADD_GRID_LEFT_HEADER_MARGIN: CGFloat = 30
let ADD_GRID_LEFT_HEADER_VIEW_WIDTH: CGFloat = (ADD_GRID_LEFT_HEADER_WIDTH / 2) + CGFloat(30.0)
var ADD_GRID_ITEM_SIZE: Float = 20

