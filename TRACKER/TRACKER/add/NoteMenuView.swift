//
//  NoteMenuView.swift
//  TRACKER
//
//  Created by NHNEnt on 2018. 8. 8..
//  Copyright © 2018년 OnlyNew. All rights reserved.
//

import UIKit

class NoteMenuView: UIView {
    
    var backButton: UIButton!
    var markButton: UIButton!
    var clearButton: UIButton!
    var clearAll: UIButton!
    
    var drawingStatus: Bool!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        drawingStatus = true
        
        backButton = UIButton(frame: CGRect(x: 10, y: 10, width: 70, height: 50))
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(UIColor.black, for: .normal)
        self.addSubview(backButton)
        
        markButton = UIButton(frame: CGRect(x: 10, y: 70, width: 70, height: 50))
        markButton.setTitle("Mark", for: .normal)
        markButton.setTitleColor(UIColor.black, for: .normal)
        self.addSubview(markButton)
        
        clearButton = UIButton(frame: CGRect(x: 10, y: 130, width: 70, height: 50))
        clearButton.setTitle("Clear", for: .normal)
        clearButton.setTitleColor(UIColor.black, for: .normal)
        self.addSubview(clearButton)
        
        clearAll = UIButton(frame: CGRect(x: 10, y: 190, width: 70, height: 50))
        clearAll.setTitle("All Clear", for: .normal)
        clearAll.setTitleColor(UIColor.black, for: .normal)
        self.addSubview(clearAll)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
