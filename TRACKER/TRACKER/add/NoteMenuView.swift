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
    var play: UIButton!


    weak var controlDelegate: NoteMenuDelegate?
    weak var viewDelegate: NoteViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        backButton = initButton(title: "Back")
        self.addSubview(backButton)
        
        markButton = initButton(title: "Mark")
        markButton.addTarget(self, action: #selector(mark), for: .touchUpInside)
        self.addSubview(markButton)
        
        clearButton = initButton(title: "Clear")
        clearButton.addTarget(self, action: #selector(clearMark), for: .touchUpInside)
        self.addSubview(clearButton)
        
        clearAll = initButton(title: "All Clear")
        self.addSubview(clearAll)
        
        save = initButton(title: "Save")
        save.addTarget(self, action: #selector(saveToFile), for: .touchUpInside)
        self.addSubview(save)
        
        play = initButton(title: "Play")
        play.addTarget(self, action: #selector(playNotes), for: .touchUpInside)
        self.addSubview(play)
        
        arrangeButtons()
    }
    
    func arrangeButtons() {
        
        var prevBtn: UIButton!
        for view in subviews {
            guard let btn = view as? UIButton else {
                continue
            }
            
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
            if prevBtn == nil {
                btn.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
            } else {
                btn.topAnchor.constraint(equalTo: prevBtn.bottomAnchor, constant: 10).isActive = true
            }
            btn.widthAnchor.constraint(equalToConstant: 70).isActive = true
            btn.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            prevBtn = btn
        }
        
    }
    
    func initButton(title: String) -> UIButton {
        let btn = UIButton(frame: CGRect.zero)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        return btn
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
    
    @objc func playNotes() {
        viewDelegate?.play()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

