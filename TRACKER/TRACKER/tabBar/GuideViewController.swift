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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
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
