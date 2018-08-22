//
//  LayoutDisplay.swift
//  TRACKER
//
//  Created by NHNEnt on 2018. 8. 8..
//  Copyright © 2018년 OnlyNew. All rights reserved.
//

import UIKit

class LayoutDisplay {
    
    func getSafeAreaInset() -> UIEdgeInsets {
        let window = UIApplication.shared.keyWindow
        let top = window?.safeAreaInsets.top
        let bottom = window?.safeAreaInsets.bottom
        let left = window?.safeAreaInsets.left
        let right = window?.safeAreaInsets.right
        
        print("safeAreaInset top:\(String(describing: top)), left:\(String(describing: left)), bottom:\(String(describing: bottom)), right:\(String(describing: right))")
        return UIEdgeInsetsMake(top!, left!, bottom!, right!)
    }
    
    
}
