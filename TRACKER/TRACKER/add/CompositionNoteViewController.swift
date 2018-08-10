//
//  CompositionNoteViewController.swift
//  TRACKER
//
//  Created by NHNEnt on 2018. 8. 7..
//  Copyright © 2018년 OnlyNew. All rights reserved.
//

import Foundation
import UIKit

class CompositionViewController: UIViewController {
    
    //    @IBOutlet var moveView: CircleView!
    var menuView: NoteMenuView!
    var gridView: GridView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuView = NoteMenuView(frame: CGRect(x: 0, y: 0, width: 90, height: self.view.frame.width))
        menuView.backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        menuView.markButton.addTarget(self, action: #selector(mark), for: .touchUpInside)
        menuView.clearButton.addTarget(self, action: #selector(clearMark), for: .touchUpInside)
        menuView.clearAll.addTarget(self, action: #selector(clearAll), for: .touchUpInside)
        self.view.addSubview(menuView)

        mark()
        
        gridView = GridView(frame: CGRect(x: menuView.frame.width, y: 0, width: self.view.frame.height - menuView.frame.width, height: self.view.frame.width))
        self.view.addSubview(gridView)
        
        self.view.translatesAutoresizingMaskIntoConstraints = false
        
        //add dot
        let taps = UITapGestureRecognizer(target: self.gridView, action:#selector(gridView.handleTapGesture(recognizer:)))
        self.gridView.addGestureRecognizer(taps)
        
//        //move grid
//        let pan = UIPanGestureRecognizer(target: self.gridView, action: #selector(gridView.handlePanGesture(recognizer:)))
//        self.gridView.addGestureRecognizer(pan)
        
        
        
        //        _ = LayoutDisplay.init().horizontalAlign(view: self.view)
        //
        //        self.view.addSubview(summaryView)
        
        
                self.view.isUserInteractionEnabled = true
        //
        //        self.view.backgroundColor = UIColor.green
        //        let label = UILabel(frame: CGRect(x: 30, y: 100, width: 300, height: 100))
        //        label.text = "이거슨.. 화면 회전 확인을 위한것이여... "
        //        self.view.addSubview(label)
        //
        
        //
        //
        
        //
        //        moveView = CircleView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        //        self.view.addSubview(moveView)
        //
        //        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(sender:)))
        //        self.moveView.addGestureRecognizer(panGesture)
        //
        OrientationLock.lock(to: .landscapeRight, andRotateTo: .landscapeRight)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        OrientationLock.lock(to: .portrait, andRotateTo: .portrait)
    }
    
    @objc func goBack() {
        self.dismiss(animated: true)
    }
    
    @objc func mark() {
        menuView.drawingStatus = true
        //MARK: 버튼 이미지로 표현하는걸로 바꾸기...
        menuView.markButton.backgroundColor = UIColor.orange
        menuView.clearButton.backgroundColor = UIColor.clear
    }
    
    @objc func clearMark() {
        menuView.drawingStatus = false
        //MARK: 버튼 이미지로 표현하는걸로 바꾸기
        menuView.clearButton.backgroundColor = UIColor.orange
        menuView.markButton.backgroundColor = UIColor.clear
    }
    
    @objc func clearAll() {
        let alertView = AlertController().showMessageWithYesFunction(byYes: clearGridView, pTitle: "초기화", pMessage: "작성된 내용이 전부 사라집니다. 정말 초기화하겠습니까?")
        self.present(alertView, animated: false)
    }
    
    func clearGridView() {
        self.gridView.gridBackground.layer.sublayers = nil
        self.gridView.gridBackground.setNeedsDisplay()
    }

    
}



