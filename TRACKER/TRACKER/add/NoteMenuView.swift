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
    var stop: UIButton!
    
    var menuView: UIView!
    var statusView: UIView!
    
    var pickerView: UIPickerView!
    var selectedBit: Int!
//    var gridSizePickerView: UIPickerView!
//    var selectedGridSize: Int!
    
    //꼭 문자여야 하는건가?
    var Array = ["60","120","180","240"]
//    var gridLenList:[String] = []

    weak var controlDelegate: NoteMenuDelegate?
    weak var viewDelegate: NoteViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        menuView = UIView()
        statusView = UIView()
        self.addSubview(menuView)
        self.addSubview(statusView)
        
        backButton = initButton(title: "Back")
        menuView.addSubview(backButton)
        
        markButton = initButton(title: "Mark")
        markButton.addTarget(self, action: #selector(mark), for: .touchUpInside)
        menuView.addSubview(markButton)
        
        clearButton = initButton(title: "Clear")
        clearButton.addTarget(self, action: #selector(clearMark), for: .touchUpInside)
        menuView.addSubview(clearButton)
        
        clearAll = initButton(title: "All Clear")
        menuView.addSubview(clearAll)
        
        save = initButton(title: "Save")
        save.addTarget(self, action: #selector(saveToFile), for: .touchUpInside)
        menuView.addSubview(save)
        
        arrangeMenuButtons()
        
        play = initButton(title: "▶️")
        play.addTarget(self, action: #selector(playNotes), for: .touchUpInside)
        statusView.addSubview(play)
        
        stop = initButton(title: "⏹")
        stop.addTarget(self, action: #selector(stopNotes), for: .touchUpInside)
        statusView.addSubview(stop)
        
        arrangeStatusButtons()
        
        
        
        
        
        
        pickerView = UIPickerView(frame: CGRect.zero)
        pickerView.delegate = self
        pickerView.dataSource = self
        addSubview(pickerView)
        
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.topAnchor.constraint(equalTo: statusView.bottomAnchor).isActive = true
        pickerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        pickerView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        pickerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
   
        //저장된게 있냐 없냐에 따라..
        selectedBit = Int(Array[0])
        
        
//        for step in 60...900 where step % 60 == 0 {
//            gridLenList.append(String(step))
//        }
//
//        gridSizePickerView = UIPickerView(frame: CGRect.zero)
//        gridSizePickerView.delegate = self
//        gridSizePickerView.dataSource = self
//        addSubview(gridSizePickerView)
//
//        gridSizePickerView.translatesAutoresizingMaskIntoConstraints = false
//        gridSizePickerView.topAnchor.constraint(equalTo: pickerView.bottomAnchor).isActive = true
//        gridSizePickerView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
//        gridSizePickerView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
//        gridSizePickerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
//
//
//        //이건. 저장된게 있냐 없냐에 따라...
//        selectedGridSize = Int(gridLenList[0])
    }
    
    func arrangeMenuButtons() {
        
        var prevBtn: UIButton!
        for view in menuView.subviews {
            guard let btn = view as? UIButton else {
                continue
            }
            
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
            if prevBtn == nil {
                btn.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
            } else {
                btn.topAnchor.constraint(equalTo: prevBtn.bottomAnchor, constant: 5).isActive = true
            }
            btn.widthAnchor.constraint(equalToConstant: 70).isActive = true
            btn.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            prevBtn = btn
        }
        
        menuView.translatesAutoresizingMaskIntoConstraints = false
        menuView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        menuView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        menuView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        menuView.bottomAnchor.constraint(equalTo: prevBtn.bottomAnchor).isActive = true
    }
    
    func arrangeStatusButtons() {
        var prevBtn: UIButton!
        for view in statusView.subviews {
            guard let btn = view as? UIButton else {
                continue
            }
            
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.topAnchor.constraint(equalTo: self.menuView.bottomAnchor, constant: 10).isActive = true
            if prevBtn == nil {
                btn.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
            } else {
                btn.leadingAnchor.constraint(equalTo: prevBtn.trailingAnchor, constant: 10).isActive = true
            }
            btn.widthAnchor.constraint(equalToConstant: 30).isActive = true
            btn.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            prevBtn = btn
        }
        
        statusView.translatesAutoresizingMaskIntoConstraints = false
        statusView.topAnchor.constraint(equalTo: menuView.bottomAnchor).isActive = true
        statusView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        statusView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        statusView.bottomAnchor.constraint(equalTo: prevBtn.bottomAnchor).isActive = true
        
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
    
    @objc func stopNotes() {
        viewDelegate?.stop()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NoteMenuView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        if pickerView == self.pickerView {
            selectedBit = Int(Array[row])
//        } else {
//            selectedGridSize = Int(gridLenList[row])
//        }
    }
}

extension NoteMenuView: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        if pickerView == self.pickerView {
            return Array[row]
//        } else {
//            return gridLenList[row]
//        }
        
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        if pickerView == self.pickerView {
            return Array.count
//        } else {
//            return gridLenList.count
//        }

    }

}
