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
    var save: UIButton!


    weak var controlDelegate: NoteMenuDelegate?
    weak var viewDelegate: NoteViewDelegate?
    
    //MARK: autolayout 으로 리펙토링 하기
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white

        backButton = UIButton(frame: CGRect(x: 10, y: 10, width: 70, height: 50))
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(UIColor.black, for: .normal)
        self.addSubview(backButton)
        
        markButton = UIButton(frame: CGRect(x: 10, y: 70, width: 70, height: 50))
        markButton.setTitle("Mark", for: .normal)
        markButton.setTitleColor(UIColor.black, for: .normal)
        markButton.addTarget(self, action: #selector(mark), for: .touchUpInside)
        self.addSubview(markButton)
        
        clearButton = UIButton(frame: CGRect(x: 10, y: 130, width: 70, height: 50))
        clearButton.setTitle("Clear", for: .normal)
        clearButton.setTitleColor(UIColor.black, for: .normal)
        clearButton.addTarget(self, action: #selector(clearMark), for: .touchUpInside)
        self.addSubview(clearButton)
        
        clearAll = UIButton(frame: CGRect(x: 10, y: 190, width: 70, height: 50))
        clearAll.setTitle("All Clear", for: .normal)
        clearAll.setTitleColor(UIColor.black, for: .normal)
        self.addSubview(clearAll)
        
        save = UIButton(frame: CGRect(x: 10, y: 250, width: 70, height: 50))
        save.setTitle("Save", for: .normal)
        save.setTitleColor(UIColor.black, for: .normal)
        save.addTarget(self, action: #selector(saveToFile), for: .touchUpInside)
        self.addSubview(save)
    }
    
    @objc func mark() {
        controlDelegate?.markingStatusChanged(isMark: true)
        markButton.backgroundColor = UIColor.orange
        clearButton.backgroundColor = UIColor.clear
    }
    
    @objc func clearMark() {
        controlDelegate?.markingStatusChanged(isMark: false)
        clearButton.backgroundColor = UIColor.orange
        markButton.backgroundColor = UIColor.clear
    }
    
    @objc func saveToFile() {
        viewDelegate?.save()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

