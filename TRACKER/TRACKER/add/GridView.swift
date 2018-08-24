//
//  GridView.swift
//  TRACKER
//
//  Created by NHNEnt on 2018. 8. 8..
//  Copyright © 2018년 OnlyNew. All rights reserved.
//

import UIKit

//MARK: 중복이나 하드코딩 등등.. 리펙토링 해보기..
class GridView: UIView {
    
    let leftHeaderWidth: CGFloat = 90
    
    var type: InstrumentKind?
    
    let circleWidth: CGFloat = 20

    var gridBackgroundBounds: CGRect!

    var gridHeaderWidth:CGFloat = 60
    
    var originTouchLocation: CGPoint!
    var originViewCenter: CGPoint!
    
    var currentScrollView: UIScrollView!
    
    // grid 격자그린 테두리를 가지는 뷰
    var contentScrollView: GridContentView!
    // 가이드라인(헤더) 뷰
    var leftScrollView: GridLeftHeaderView!
    // marking calyaer 를 가지는 뷰
    
    
    
    weak var gridDelegate: GridDelegate?
    
    var timeline = SoundTimeLine(type: InstrumentKind.PIANO)

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.isUserInteractionEnabled = true
        self.backgroundColor = UIColor.black

        getGridBounds()
        
        leftScrollView = GridLeftHeaderView(frame: frame)
        self.addSubview(leftScrollView)
        leftScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        leftScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        leftScrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        leftScrollView.widthAnchor.constraint(equalToConstant: leftHeaderWidth).isActive = true
        leftScrollView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        contentScrollView = GridContentView(frame: frame)
        self.addSubview(contentScrollView)
        contentScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        contentScrollView.leftAnchor.constraint(equalTo: leftScrollView.rightAnchor).isActive = true
        contentScrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        contentScrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        contentScrollView.gridViewDelegate = self
        leftScrollView.gridViewDelegate = self
        
    }
    
    func getGridBounds() {
        //MARK: 나중에 type 을 enum으로 비교해서 로직 분리하는걸... 찾아보기
        let typeProperties = TYPE_PIANO.self
        print("gridBackground size > width:\(typeProperties.getWidth), height:\(typeProperties.getHeight)")
        gridBackgroundBounds = CGRect(x: 0, y: 0, width: typeProperties.getWidth, height: typeProperties.getHeight)
    }
    
    
    
    
    func combineNoteLabel(row: Int) -> String {
        let noteText = TYPE_PIANO_NOTE_SCALE_TEXT[row % TYPE_PIANO_NOTE_SCALE_TEXT.count]
        let octaveText = CGFloat(row / TYPE_PIANO_NOTE_WHITE_SCALE_HEIGHT.count).rounded(.down)
        return noteText + String(describing: Int(octaveText) + 1)
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    

 
    
}

extension GridView: UIScrollViewDelegate {


    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        currentScrollView = scrollView
        print("시작")
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //양쪽에서 스크롤이 발생하니까..... 꼬이면서 바운스가 안먹음.. 이건.. 뷰를 노나야 할까 싶은데... 파일을.. 노나서.. 델리게이트를 따로 가져오고... 싱크용 커스텀 델리게이트를 생성해줘야...겠...?
        
//        if currentScrollView != nil {
//            if currentScrollView == self.scrollView {
//                print("current - 그리드")
//                synchronizeScrollView(scrollKeyView, toScrollView: self.scrollView)
//            } else if currentScrollView == scrollKeyView {
//                print("current - 헤더")
//
//                synchronizeScrollView(self.scrollView, toScrollView: scrollKeyView)
//            }
//        } else {
            if scrollView == self.contentScrollView {
                print("normal - 그리드")
                synchronizeScrollView(leftScrollView.scrollView, toScrollView: contentScrollView.scrollView)
            } else if scrollView == leftScrollView {
                print("normal - 헤더")
                synchronizeScrollView(contentScrollView.scrollView, toScrollView: leftScrollView.scrollView)
            }
//        }

    }
    
    func synchronizeScrollView(_ scrollViewToScroll: UIScrollView, toScrollView scrolledView: UIScrollView) {
        var offset = scrollViewToScroll.contentOffset
        offset.y = scrolledView.contentOffset.y
        scrollViewToScroll.setContentOffset(offset, animated: false)
    }
    
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        currentScrollView = nil
        print("종료")
    }
    


    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
//        if scrollView == self.scrollView {
//            scrollKeyView.setZoomScale(scale, animated: true)
////            scrollViewWillBeginDragging(self.scrollView)
////            scrollViewDidScroll(self.scrollView )
//        } else if scrollView == scrollKeyView {
//            self.scrollView.setZoomScale(scale, animated: true)
////            scrollViewWillBeginDragging(scrollKeyView)
////            scrollViewDidScroll(scrollKeyView)
//        }
    }
    
//    func scrollViewDidZoom(_ scrollView: UIScrollView) {
////        if scrollView == self.scrollView {
//
////        } else {
//            print("zoom ... view > width:\(leftHeaderView.frame.width), height:\(leftHeaderView.frame.height)")
//            scrollKeyView.frame = CGRect(x: 0, y: 0, width: leftHeaderView.frame.width, height: leftHeaderView.frame.height)
//
//            let originalRect = self.scrollView.frame
//            print("original scrollView > x:\(self.scrollView.frame.origin.x), y:\(self.scrollView.frame.origin.y), width:\(self.scrollView.frame.size.width), height:\(self.scrollView.frame.size.height)")
//
//            let diff = leftHeaderView.frame.width - originalRect.origin.x
//            self.scrollView.frame = CGRect(x: originalRect.origin.x + diff, y: 0, width: originalRect.size.width - diff, height: originalRect.size.height)
////            print("original offset > x:\(self.scrollView.contentOffset.x), y:\(self.scrollView.contentOffset.y)")
////            self.scrollView.frame = CGRect(x: gridLeftHeader.frame.width, y: 0, width: self.scrollView.frame.size.width - gridLeftHeader.frame.width, height: self.scrollView.frame.size.height)
////        }
//    }

}

extension GridView: NoteGridViewDelegate {
    
    func play() {
        let cols = TYPE_PIANO.cols.rawValue

        var dat: [Int:String] = [:]

        contentScrollView.notes.forEach { (key, value) in
            dat[key] = String(format: "%03d", Int(CGFloat(key / cols).rounded(.down)))

        }

        timeline.buildSoundArray(size: contentScrollView.notes.count, notes: dat)
        timeline.playSounds()

    }
    
    func stop() {
        timeline.stop()
    }
    
    
    func loadSaved(fileName: String) {
        let fileManager = ONFileManager()
        let contents = fileManager.readFileSeparatedCR(fileName: fileName)

        contents.split(separator: "\n").forEach { (str) in
            let parsed = str.split(separator: ",")

            let x = CGFloat(truncating: NumberFormatter().number(from: String(parsed[1]))!)
            let y = CGFloat(truncating: NumberFormatter().number(from: String(parsed[2]))!)
            let width = CGFloat(truncating: NumberFormatter().number(from: String(parsed[3]))!)
            let height = CGFloat(truncating: NumberFormatter().number(from: String(parsed[4]))!)

            contentScrollView.drawRect(idx: Int(parsed[0])!, rect: CGRect(x: x, y: y, width: width, height: height))
        }
    }
    
    
    //MARK: 오래걸리면.. indicator 같은거
    func save(fileName: String) {
        guard fileName != "" else {
            gridDelegate?.warning(message: "파일명이 제대로 입력되지 않아서 저장 할 수 없습니다")
            return
        }

        var saveContents: String = ""

        contentScrollView.notes.forEach { (key, value) in
            let rect = value.frame

            //index,x,y,width,height
            saveContents = saveContents.appendingFormat("%d,%f,%f,%f,%f\n", key, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
        }
        let fileManager = ONFileManager()
        fileManager.saveToDatFileSeparatedCR(fileName: fileName, contents: saveContents)

        //MARK: ENUM 타입을 넣을 수 없음.. 일단 문자열 하드코딩
        UserDefaults.standard.set("PIANO", forKey: fileName)

        gridDelegate?.alert(message: "저장 완료")
    }
    
}

extension GridView: GridViewDelegate {
    //content -> header
    
    //흠.. 모르겠다.. 결국 원점이네..
    //
    func synchronizeScrollView(occurView: UIScrollView) {
        if occurView == leftScrollView.scrollView {
            var orgOffset = contentScrollView.scrollView.contentOffset
            orgOffset.y = occurView.contentOffset.y
            
            contentScrollView.scrollView.setContentOffset(orgOffset, animated: false)
            contentScrollView.currentScrollView = nil
        } else {
            var orgOffset = leftScrollView.scrollView.contentOffset
            orgOffset.y = occurView.contentOffset.y
            
            leftScrollView.scrollView.setContentOffset(orgOffset, animated: false)
            leftScrollView.currentScrollView = nil
        }

        
//        if(occurView.superview?.isKind(of: GridContentView.self))! {
//            var orgOffset = leftScrollView.scrollView.contentOffset
//            orgOffset.y = occurView.contentOffset.y
//            leftScrollView.currentScrollView = occurView
//
//            leftScrollView.scrollView.setContentOffset(orgOffset, animated: false)
//            leftScrollView.currentScrollView = nil
//        } else {
//            var orgOffset = contentScrollView.scrollView.contentOffset
//            orgOffset.y = occurView.contentOffset.y
//            contentScrollView.currentScrollView = occurView
//
//            contentScrollView.scrollView.setContentOffset(orgOffset, animated: false)
//            contentScrollView.currentScrollView = nil
//        }
    }
    
    
}




