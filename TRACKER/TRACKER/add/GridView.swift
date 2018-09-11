//
//  GridView.swift
//  TRACKER
//
//  Created by NHNEnt on 2018. 8. 8..
//  Copyright © 2018년 OnlyNew. All rights reserved.
//

import UIKit

//MARK: 중복이나 하드코딩 등등.. 리펙토링..
class GridView: UIView {
    
    var leftHeaderWidth: CGFloat = 90
    
    var type: InstrumentType!
    
    var circleWidthScaled: CGFloat!

    var gridHeaderWidth:CGFloat = 60
    let sliderViewHeight:CGFloat = 75
    
    var originTouchLocation: CGPoint!
    var originViewCenter: CGPoint!
   
    // grid 격자그린 테두리를 가지는 뷰
    var contentScrollView: GridContentView!
    // 가이드라인(헤더)
    var leftScrollView: GridLeftHeaderView!
    // slider
    var sliderView: SeekBarSliderView!
    var arrowView: UIView!
    
    //animation
    var propertyAnimatorSlider: UIViewPropertyAnimator!
    var propertyAnimatorArrow: UIViewPropertyAnimator!
    var propertyAnimatorGrid: UIViewPropertyAnimator!
    
    weak var gridDelegate: GridDelegate?
    
    lazy var timeline = SoundTimeLine(type: self.type)

    init(frame: CGRect, type: InstrumentType) {
        super.init(frame: frame)

        self.type = type
        self.isUserInteractionEnabled = true
        self.backgroundColor = UIColor.white
        circleWidthScaled = CGFloat(type.gridSize)

        let safeAreaInset = LayoutDisplay().getSafeAreaInset()
       
        sliderView = SeekBarSliderView(frame: frame, type: type)
        self.addSubview(sliderView)
        sliderView.translatesAutoresizingMaskIntoConstraints = false
        
        sliderView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: type.getHeaderWidth()).isActive = true
        sliderView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        sliderView.heightAnchor.constraint(equalToConstant: sliderViewHeight).isActive = true
        sliderView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -(safeAreaInset.right + CGFloat(type.margin))).isActive = true
        
        leftScrollView = GridLeftHeaderView(frame: frame, type: type)
        self.addSubview(leftScrollView)
        leftScrollView.translatesAutoresizingMaskIntoConstraints = false
        leftScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        leftScrollView.topAnchor.constraint(equalTo: self.sliderView.bottomAnchor).isActive = true
        leftScrollView.widthAnchor.constraint(equalTo: leftScrollView.leftHeader.widthAnchor).isActive = true
        leftScrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        contentScrollView = GridContentView(frame: frame, type: type)
        self.addSubview(contentScrollView)
        contentScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        contentScrollView.leftAnchor.constraint(equalTo: leftScrollView.rightAnchor).isActive = true
        contentScrollView.topAnchor.constraint(equalTo: sliderView.bottomAnchor).isActive = true
        contentScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        contentScrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        leftScrollView.gridViewDelegate = self
        contentScrollView.gridViewDelegate = self
        sliderView.seekBarDelegate = self
        
    }

    func combineNoteLabel(row: Int) -> String {
        let noteText = TYPE_PIANO_NOTE_SCALE_TEXT[row % TYPE_PIANO_NOTE_SCALE_TEXT.count]
        let octaveText = CGFloat(row / TYPE_PIANO_NOTE_WHITE_SCALE_HEIGHT.count).rounded(.down)
        return noteText + String(describing: Int(octaveText) + 1)
    }
    
    func stopSoundAndAnimation() {
        if let grid = propertyAnimatorGrid {
            grid.stopAnimation(true)
        }
        
        if let arrow = propertyAnimatorArrow {
            arrow.stopAnimation(true)
        }
        
        if let slider = propertyAnimatorSlider {
            let arrowPos = (sliderView.seekArrow.frame.origin.x / (CGFloat(type.gridSize) * contentScrollView.scrollView.zoomScale)).rounded(.down)
            let gridPos = (contentScrollView.grid.frame.origin.x / (CGFloat(type.gridSize) * contentScrollView.scrollView.zoomScale)).rounded(.down)
            sliderView.mySlider.setValue(Float(arrowPos + gridPos), animated: false)
            slider.stopAnimation(true)
        }

        timeline.stop(curPos: Int(sliderView.mySlider.value))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
}




extension GridView: NoteGridViewDelegate {
    
    func play(bit: Int) {
        stop()
        
        contentScrollView.scrollView.isScrollEnabled = false
        
        let cols = type.cols

        var dat: [Int:String] = [:]

        contentScrollView.notes.forEach { (key, value) in
            dat[key] = String(format: "%@-%03d", type.type.rawValue, Int(CGFloat(key / cols).rounded(.down)))
        }

        timeline.buildSoundArray(size: contentScrollView.notes.count, notes: dat, bit: 60.0 / Double(bit), startPoint: sliderView.mySlider.value.rounded(.down))
        timeline.playSounds(sliderSync: moveToAnimated)
        
    }
    
    func stop() {
        contentScrollView.scrollView.isScrollEnabled = true
        stopSoundAndAnimation()
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
    
    //MARK: 내용이 중복되니까 리펙토링
    func moveToAnimated(pos: Float, duration: Double, bit: Double, startPoint: Int) {

        let viewFirstPosition = (contentScrollView.scrollView.contentOffset.x / CGFloat(type.gridSize)).rounded(.down)

        let sliderMaxPosCnt:CGFloat = (sliderView.frame.size.width / CGFloat(type.gridSize)).rounded(.down)
        let sliderMaxPosition: CGFloat = sliderMaxPosCnt * CGFloat(type.gridSize)

        propertyAnimatorSlider = UIViewPropertyAnimator(duration: Double(pos - Float(startPoint)) * bit, curve: UIViewAnimationCurve.linear)
        propertyAnimatorSlider.addAnimations {
            self.sliderView.mySlider.setValue(pos, animated: true)
        }
        propertyAnimatorSlider.addCompletion { (_) in
            self.contentScrollView.scrollView.isScrollEnabled = true
        }
        propertyAnimatorSlider.startAnimation()

        //화면을 넘어갈 경우 화살표는 끝에서 멈추고 그리드가 왼쪽으로 이동
        if CGFloat(pos) > viewFirstPosition + sliderMaxPosCnt {
            propertyAnimatorArrow = UIViewPropertyAnimator(duration: Double(((viewFirstPosition + sliderMaxPosCnt) - CGFloat(startPoint))) * bit, curve: UIViewAnimationCurve.linear)
            propertyAnimatorArrow.addAnimations {
                self.sliderView.seekArrow.frame = CGRect(x: CGFloat(sliderMaxPosition), y: self.sliderView.arrowTopInset, width: CGFloat(self.type.gridSize), height: 20.0)
            }
            propertyAnimatorArrow.startAnimation()
            
            propertyAnimatorGrid = UIViewPropertyAnimator(duration: Double((CGFloat(pos) - (viewFirstPosition + sliderMaxPosCnt))) * bit, curve: UIViewAnimationCurve.linear)
            propertyAnimatorGrid.addAnimations {
                self.contentScrollView.scrollView.contentOffset.x = (CGFloat(pos) - sliderMaxPosCnt) * CGFloat(self.type.gridSize)
            }
            propertyAnimatorGrid.startAnimation(afterDelay: Double(((viewFirstPosition + sliderMaxPosCnt) - CGFloat(startPoint))) * bit)
        } else {
            //화면을 넘어갈 경우 화살표 는 끝까지 표시만
            propertyAnimatorArrow = UIViewPropertyAnimator(duration: Double(CGFloat(pos) - viewFirstPosition) * bit, curve: UIViewAnimationCurve.linear)
            propertyAnimatorArrow.addAnimations {
                self.sliderView.seekArrow.frame = CGRect(x: CGFloat(pos * self.type.gridSize), y: self.sliderView.arrowTopInset, width: CGFloat(self.type.gridSize), height: 20.0)
            }
            propertyAnimatorArrow.startAnimation()
        }
        
    }
    
    
    
}

extension GridView: GridViewDelegate {
    func synchronizeSliderView(pos: CGFloat) {
        
        let arrowPos = (sliderView.seekArrow.frame.origin.x / CGFloat(circleWidthScaled)).rounded(.down)

        sliderView.mySlider.value = Float(pos + arrowPos)
    }
    

    func synchronizeScrollViewZoom(scale: CGFloat, scrollView: UIScrollView) {
        
        if timeline.isPlaying() {
            stopSoundAndAnimation()
            return
        }
        
        circleWidthScaled = CGFloat(type.gridSize) * scale

        if (scrollView.superview?.isKind(of: GridLeftHeaderView.self))! {
            contentScrollView.scrollView.setZoomScale(scale, animated: true)
        } else {
            leftScrollView.scrollView.setZoomScale(scale, animated: true)
        }
        
        leftScrollView.scrollView.translatesAutoresizingMaskIntoConstraints = true
        leftScrollView.scrollView.frame = CGRect(x: 0, y: 0, width: leftScrollView.leftHeader.frame.size.width, height: leftScrollView.frame.size.height)
        leftScrollView.frame = CGRect(x: 0, y: sliderViewHeight, width: leftScrollView.leftHeader.frame.size.width, height: leftScrollView.frame.size.height)
        
        contentScrollView.scrollView.translatesAutoresizingMaskIntoConstraints = true
        contentScrollView.frame = CGRect(x: leftScrollView.leftHeader.frame.size.width, y: sliderViewHeight, width: self.frame.size.width - leftScrollView.leftHeader.frame.size.width , height: contentScrollView.frame.size.height)
        contentScrollView.scrollView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width - leftScrollView.leftHeader.frame.size.width , height: contentScrollView.frame.size.height)
        
        sliderView.translatesAutoresizingMaskIntoConstraints = true
        
        sliderView.frame = CGRect(x: leftScrollView.leftHeader.frame.size.width, y: 0, width: self.frame.size.width - leftScrollView.leftHeader.frame.size.width  - 30 , height: sliderView.frame.size.height)
    }
    
    func synchronizeScrollViewY(pointY: CGFloat) {
        var orgOffset = contentScrollView.scrollView.contentOffset
        orgOffset.y = pointY
        contentScrollView.currentScrollY = pointY
        contentScrollView.scrollView.setContentOffset(orgOffset, animated: false)
    }
}

extension GridView: GridSeekBarDelegate {
    func moveTo(pos: Float) {
        let zoomScale = contentScrollView.scrollView.zoomScale
        let gridSize = CGFloat(type.gridSize) * zoomScale
        
 
        let viewFirstPosition = (contentScrollView.scrollView.contentOffset.x / gridSize).rounded(.down)

        let sliderMaxPosCnt:CGFloat = (sliderView.frame.size.width / gridSize).rounded(.down)
        let sliderMaxPosition: CGFloat = sliderMaxPosCnt * gridSize

        let curSliderPosition:CGFloat = (CGFloat(pos) - viewFirstPosition) * gridSize
        
        if CGFloat(pos) > viewFirstPosition + sliderMaxPosCnt {
            sliderView.seekArrow.frame = CGRect(x: sliderMaxPosition, y: CGFloat(sliderView.arrowTopInset), width: CGFloat(type.gridSize), height: 20.0)
            contentScrollView.scrollView.contentOffset.x = (CGFloat(pos) - sliderMaxPosCnt) * gridSize
        } else if CGFloat(pos) > viewFirstPosition && CGFloat(pos) < viewFirstPosition + sliderMaxPosCnt  {
            sliderView.seekArrow.frame = CGRect(x: curSliderPosition, y: sliderView.arrowTopInset, width: CGFloat(type.gridSize), height: 20.0)
        } else if CGFloat(pos) < viewFirstPosition + sliderMaxPosCnt {
            sliderView.seekArrow.frame = CGRect(x: 0, y: sliderView.arrowTopInset, width: CGFloat(type.gridSize), height: 20.0)
            //MARK: contentOffset 과 bounds 의 차이
            contentScrollView.scrollView.contentOffset.x = CGFloat(pos) * gridSize
        }
    }
    
    
}





