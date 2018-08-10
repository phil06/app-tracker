//
//  StaticCommonData.swift
//  TRACKER
//
//  Created by NHNEnt on 2018. 8. 7..
//  Copyright © 2018년 OnlyNew. All rights reserved.
//

import UIKit

//MARK: 악기 선택 아이콘
enum InstrumentKind: Int {
    case PIANO
    case GUITAR
    case DRUM
    
    static let count: Int = {
        var max: Int = 0
        while let _ = InstrumentKind(rawValue: max) { max += 1 }
        return max
    }()
}

//MARK: 탭바 이미지 (나중에 바꾸기)
enum TabBarImage: String {
    case TAB_BAR_ITEM_HOME_IMG
    case TAB_BAR_ITEM_NEW_IMG
    case TAB_BAR_ITEM_LIST_IMG
    
    var getFileName: String {
        switch self {
        case .TAB_BAR_ITEM_HOME_IMG:
            return "icon_info"
        case .TAB_BAR_ITEM_NEW_IMG:
            return "icon_info"
        case .TAB_BAR_ITEM_LIST_IMG:
            return "icon_info"
        }
    }
}



