//
//  GridDelegate.swift
//  TRACKER
//
//  Created by saera on 2018. 8. 16..
//  Copyright © 2018년 OnlyNew. All rights reserved.
//

import UIKit

protocol GridDelegate: class {
    func warning(message: String)
    func alert(message: String)
}

protocol GridViewDelegate: class {
    func synchronizeScrollView(occurView: UIScrollView)
}
