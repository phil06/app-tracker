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
    
    var leftHeaderWidth: CGFloat = 90
    
    var type: InstrumentKind?
    
    let circleWidth: CGFloat = 20
    var circleWidthScaled: CGFloat!

    var gridBackgroundBounds: CGRect!

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
    
    weak var gridDelegate: GridDelegate?
    
    var timeline = SoundTimeLine(type: InstrumentKind.PIANO)

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.isUserInteractionEnabled = true
        self.backgroundColor = UIColor.white

        getGridBounds()
        
        let safeAreaInset = LayoutDisplay().getSafeAreaInset()
       
        sliderView = SeekBarSliderView(frame: frame)
        self.addSubview(sliderView)
        sliderView.translatesAutoresizingMaskIntoConstraints = false
        
        sliderView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: ADD_GRID_LEFT_HEADER_VIEW_WIDTH).isActive = true
        sliderView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        sliderView.heightAnchor.constraint(equalToConstant: sliderViewHeight).isActive = true
        sliderView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -(safeAreaInset.right + ADD_GRID_LEFT_HEADER_MARGIN)).isActive = true
        
        
  
        leftScrollView = GridLeftHeaderView(frame: frame)
        self.addSubview(leftScrollView)
        leftScrollView.translatesAutoresizingMaskIntoConstraints = false
        leftScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        leftScrollView.topAnchor.constraint(equalTo: self.sliderView.bottomAnchor).isActive = true
        leftScrollView.widthAnchor.constraint(equalTo: leftScrollView.leftHeader.widthAnchor).isActive = true
        leftScrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        
        
        

        
        
        contentScrollView = GridContentView(frame: frame)
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
    
    func stopSoundAndAnimation() {
        print("멈춰야 하는뎅...")
//        self.sliderView.layer.removeAllAnimations()
//        self.sliderView.seekArrow.stopAnimating()
        timeline.stop()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
}




extension GridView: NoteGridViewDelegate {
    
    func play(bit: Int) {
        let cols = TYPE_PIANO.cols.rawValue

        var dat: [Int:String] = [:]

        contentScrollView.notes.forEach { (key, value) in
            dat[key] = String(format: "%03d", Int(CGFloat(key / cols).rounded(.down)))
        }
        
        print("슬라이더 위치 : \(sliderView.mySlider.value.rounded(.down))")

        timeline.buildSoundArray(size: contentScrollView.notes.count, notes: dat, bit: 60.0 / Double(bit), startPoint: sliderView.mySlider.value.rounded(.down))

        timeline.playSounds(sliderSync: moveToAnimated)
        
    }
    
    func stop() {
        if timeline.isPlaying() {
            stopSoundAndAnimation()
            return
        }
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
        print("애니메이션.. 마지막 위치 : \(pos)")
        
        let viewFirstPosition = (contentScrollView.scrollView.contentOffset.x / 20).rounded(.down)
        print("그리드 뷰의 처음 인덱스(화면에 보이는) : \(viewFirstPosition)")
        
        let sliderMaxPosCnt:CGFloat = (sliderView.frame.size.width / 20).rounded(.down)
        let sliderMaxPosition: CGFloat = sliderMaxPosCnt * 20
        print("그리드 뷰의 x 를 옮겨야 하는 최대 그리드 수 : \(sliderMaxPosCnt), 슬라이더의 최대 위치:\(sliderMaxPosition)")
        
        let propertyAnimatorSlider: UIViewPropertyAnimator = UIViewPropertyAnimator(duration: duration, curve: UIViewAnimationCurve.easeInOut)
        propertyAnimatorSlider.addAnimations {
            self.sliderView.mySlider.setValue(pos, animated: true)
        }
        propertyAnimatorSlider.startAnimation()
        
        

        
        //화면을 넘어갈 경우 화살표는 끝에서 멈추고 그리드가 왼쪽으로 이동
        if CGFloat(pos) > viewFirstPosition + sliderMaxPosCnt {
            let propertyAnimatorArrow: UIViewPropertyAnimator = UIViewPropertyAnimator(duration: Double(((viewFirstPosition + sliderMaxPosCnt) - CGFloat(startPoint)) + 1) * bit, curve: UIViewAnimationCurve.linear)
            propertyAnimatorArrow.addAnimations {
                self.sliderView.seekArrow.frame = CGRect(x: Int(sliderMaxPosition), y: self.sliderView.arrowTopInset, width: 20, height: 20)
            }
            propertyAnimatorArrow.startAnimation()
            
            let propertyAnimatorGrid: UIViewPropertyAnimator = UIViewPropertyAnimator(duration: Double((CGFloat(pos) - (viewFirstPosition + sliderMaxPosCnt))) * bit, curve: UIViewAnimationCurve.linear)
            propertyAnimatorGrid.addAnimations {
                self.contentScrollView.scrollView.contentOffset.x = (CGFloat(pos) - sliderMaxPosCnt) * 20
            }
            propertyAnimatorGrid.startAnimation(afterDelay: Double(((viewFirstPosition + sliderMaxPosCnt) - CGFloat(startPoint)) + 1) * bit)
        } else {
            //화면을 넘어갈 경우 화살표 는 끝까지 표시만
            let propertyAnimatorArrow: UIViewPropertyAnimator = UIViewPropertyAnimator(duration: Double(CGFloat(pos) - viewFirstPosition) * bit, curve: UIViewAnimationCurve.linear)
            propertyAnimatorArrow.addAnimations {
                self.sliderView.seekArrow.frame = CGRect(x: Int(pos * 20), y: self.sliderView.arrowTopInset, width: 20, height: 20)
            }
            propertyAnimatorArrow.startAnimation()
        }
        
    }
    
    
    
}

extension GridView: GridViewDelegate {
    func synchronizeSliderView(pos: CGFloat) {
        
        //슬라이더 기준의 value가 아니라 그리드뷰의 x위치 기준으로 계산해야 함...
        
        // 현재 슬라이더의 값
        print("current slider value:\(sliderView.mySlider.value)")
        // 현재 화살표의 위치
        print("current arrow posIdx:\((sliderView.seekArrow.frame.origin.x / 20).rounded(.down))")
        // 그리드의 x 위치
        print("current gridView pos x:\(pos)")
        
        let arrowPos = (sliderView.seekArrow.frame.origin.x / 20).rounded(.down)

        sliderView.mySlider.value = Float(pos + arrowPos)
    }
    

    func synchronizeScrollViewZoom(scale: CGFloat, scrollView: UIScrollView) {
        
        if timeline.isPlaying() {
            stopSoundAndAnimation()
            return
        }
        
        circleWidthScaled = circleWidth * scale
        print("scale:\(scale), circleWidthScaled:\(circleWidthScaled)")
        
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
        
        if timeline.isPlaying() {
            stopSoundAndAnimation()
            return
        }
        
        //이러면 어찌될라나..?
        sliderView.mySlider.value = pos
        
        //이거.... 뭔가 움직임이.... 확인중
        print("전체 그리드중 화살표의 인덱스 값 : \(pos)")
        
        //view의 기준
        let viewFirstPosition = (contentScrollView.scrollView.contentOffset.x / 20).rounded(.down)
        print("그리드 뷰의 처음 인덱스(화면에 보이는) : \(viewFirstPosition)")
        
        let sliderMaxPosCnt:CGFloat = (sliderView.frame.size.width / 20).rounded(.down)
        let sliderMaxPosition: CGFloat = sliderMaxPosCnt * 20
        print("그리드 뷰의 x 를 옮겨야 하는 최대 그리드 수 : \(sliderMaxPosCnt), 슬라이더의 최대 위치:\(sliderMaxPosition)")
        
        let curSliderPosition:CGFloat = (CGFloat(pos) - viewFirstPosition) * 20
        
        if CGFloat(pos) > viewFirstPosition + sliderMaxPosCnt {
            print("case1")
            //화살은 맨끝, 그리드뷰.x 를 이동
            sliderView.seekArrow.frame = CGRect(x: Int(sliderMaxPosition), y: sliderView.arrowTopInset, width: 20, height: 20)
            //MARK: 왜 없는 영역인 왼쪽으로 끄는게 -가 아니라 + 인거지...?
            contentScrollView.scrollView.contentOffset.x = (CGFloat(pos) - sliderMaxPosCnt) * 20
        } else if CGFloat(pos) > viewFirstPosition && CGFloat(pos) < viewFirstPosition + sliderMaxPosCnt  {
            print("case2")
            //그리드뷰.x 는 이동하지 않음 + 화살은 포지션에 맞는 위치에
            sliderView.seekArrow.frame = CGRect(x: Int(curSliderPosition), y: sliderView.arrowTopInset, width: 20, height: 20)
        } else if CGFloat(pos) < viewFirstPosition + sliderMaxPosCnt {
            print("case3")
            //화살은 맨 처음, 그리드뷰.x 를 이동
            sliderView.seekArrow.frame = CGRect(x: 0, y: sliderView.arrowTopInset, width: 20, height: 20)
            //MARK: 왜 없는 영역인 왼쪽으로 끄는게 -가 아니라 + 인거지...?
            contentScrollView.scrollView.contentOffset.x = CGFloat(pos) * 20
        }
    }
    
    
}





