//
//  OrientationStruct.swift
//  TRACKER
//
//  Created by NHNEnt on 2018. 8. 7..
//  Copyright © 2018년 OnlyNew. All rights reserved.
//

import UIKit

struct OrientationLock {
    static func lock(to orientation: UIInterfaceOrientationMask) {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    
    static func lock(to orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation: UIInterfaceOrientation) {
        self.lock(to: orientation)
        // 디바이스가 locationLeft 상태에서 locationRight로 설정해도 동작하지 않는다. 반대도 마찬가지다.
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    }
}
