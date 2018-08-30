//
//  TimeFormatter.swift
//  TRACKER
//
//  Created by saera on 2018. 8. 31..
//  Copyright © 2018년 OnlyNew. All rights reserved.
//

import UIKit

extension TimeInterval {
    //print("실행시간 > \(String(describing: (fixed + delay).format(using: [.year, .month, .day, .hour, .minute, .second])))")
    func format(using units: NSCalendar.Unit) -> String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = units
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .pad
        
        return formatter.string(from: self)
    }
}
