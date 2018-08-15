//
//  CompositionNoteViewController.swift
//  TRACKER
//
//  Created by NHNEnt on 2018. 8. 7..
//  Copyright © 2018년 OnlyNew. All rights reserved.
//

import Foundation
import UIKit

//MARK: instrumentType 에 따라 화면을 달리 해야하는걸... 여기서 할지 GridView에서 할지는 모르겠지만 일단 해야할일..
class CompositionViewController: UIViewController {
    
    var menuView: NoteMenuView!
    var gridView: GridView!
    var instrumentType: InstrumentKind!
    
    weak var controlDelegate: NoteMenuDelegate?
    weak var gridViewDelegate: NoteGridViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        OrientationLock.lock(to: .landscapeRight, andRotateTo: .landscapeRight)
        
        let safeAreaInset = LayoutDisplay().getSafeAreaInset()
        
        self.view.backgroundColor = UIColor.white
        
        //메뉴
        menuView = NoteMenuView(frame: CGRect.zero)
        menuView.backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        menuView.clearAll.addTarget(self, action: #selector(clearAll), for: .touchUpInside)
        menuView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(menuView)
        
        menuView.widthAnchor.constraint(equalToConstant: 90.0).isActive = true
        menuView.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        menuView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: safeAreaInset.left).isActive = true
        menuView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true

        menuView.controlDelegate = self
        menuView.viewDelegate = self
        
        //그리는 화면
        gridView = GridView(frame: CGRect.zero)
        gridView.type = instrumentType
        gridView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(gridView)

        gridView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        gridView.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        gridView.leadingAnchor.constraint(equalTo: menuView.trailingAnchor).isActive = true
        gridView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        
        gridView.gridDelegate = self
        
        controlDelegate = gridView
        gridViewDelegate = gridView
        
        //add dot
        self.view.isUserInteractionEnabled = true
        
        let taps = UITapGestureRecognizer(target: self.gridView, action:#selector(gridView.handleTapGesture(recognizer:)))
        self.gridView.addGestureRecognizer(taps)

        menuView.mark()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Don't forget to reset when view is being removed
        OrientationLock.lock(to: .portrait, andRotateTo: .portrait)
    }
    
    @objc func goBack() {
        self.dismiss(animated: true)
    }

    @objc func clearAll() {
        let alertView = AlertController().showMessageWithYesFunction(byYes: clearGridView, pTitle: "초기화", pMessage: "작성된 내용이 전부 사라집니다. 정말 초기화하겠습니까?")
        self.present(alertView, animated: false)
    }
    
    func clearGridView() {
        self.gridView.notes = [Int:CALayer]()
        self.gridView.grid.layer.sublayers = nil
        self.gridView.grid.setNeedsDisplay()
    }
    
    func saveGrid(name: String) {
        gridViewDelegate?.save(fileName: name)
    }

}

extension CompositionViewController: NoteViewDelegate {
    func save() {
        let alertView = AlertController().showMessageWithInput(by: saveGrid, pTitle: "저장", pMessage: "작성된 내용을 저장합니다")
        self.present(alertView, animated: false)
    }
}

extension CompositionViewController: NoteMenuDelegate {
    func markingStatusChanged(isMark: Bool) {
        controlDelegate?.markingStatusChanged(isMark: isMark)
    }
}

extension CompositionViewController: GridDelegate {
    func warning(message: String) {
        let alertView = AlertController().showMessage(title: "오류", message: message)
        self.present(alertView, animated: false)
    }
}




