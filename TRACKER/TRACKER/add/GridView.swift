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
    
    
    var notes:[Int:CALayer] = [Int:CALayer] ()
    
    var type: InstrumentKind?
    
    let circleWidth: CGFloat = 20

    var gridBackgroundBounds: CGRect!
    var gridBoundMargin:CGFloat = 30
    var gridHeaderWidth:CGFloat = 60
    
    var originTouchLocation: CGPoint!
    var originViewCenter: CGPoint!
    
    var scrollView: UIScrollView!
    var scrollKeyView: UIScrollView!
    var currentScrollView: UIScrollView!
    
    // grid 격자그린 테두리를 가지는 뷰
    var gridBackground: UIView!
    // 가이드라인 뷰
    var gridLeftHeader: UIView!
    // marking calyaer 를 가지는 뷰
    var grid: UIView!
    
    var isMarking: Bool!
    
    weak var gridDelegate: GridDelegate?
    
    var timeline = SoundTimeLine(type: InstrumentKind.PIANO)

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.isUserInteractionEnabled = true
        self.backgroundColor = UIColor.black

        getGridBounds()
        
        grid = UIView(frame: CGRect(x: 0, y: gridBoundMargin, width: gridBackgroundBounds.width, height: gridBackgroundBounds.height))
        grid.backgroundColor = UIColor.clear
        grid.layer.borderWidth = 1
        grid.layer.borderColor = UIColor.black.cgColor
        
        gridBackground = UIView(frame: CGRect(x: 0, y: 0, width: gridBackgroundBounds.width + gridBoundMargin, height: gridBackgroundBounds.height + (gridBoundMargin * 2)))
        gridBackground.backgroundColor = UIColor.white
        gridBackground.addSubview(grid)
        
        
        
        gridLeftHeader = UIView(frame: CGRect(x: 0, y: 0,
                                              width: gridBoundMargin + (gridHeaderWidth / 2) + CGFloat(30.0),
                                              height: gridBackgroundBounds.height + (gridBoundMargin * 2)))
        gridLeftHeader.backgroundColor = UIColor.white
        drawHeader()
        
        scrollKeyView = UIScrollView(frame: frame)
        scrollKeyView.contentSize = gridLeftHeader.bounds.size
        scrollKeyView.maximumZoomScale = 3.0
        scrollKeyView.minimumZoomScale = 1.0
        scrollKeyView.delegate = self
        scrollKeyView.addSubview(gridLeftHeader)
        scrollKeyView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scrollKeyView)
        scrollKeyView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        scrollKeyView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        scrollKeyView.widthAnchor.constraint(equalTo: gridLeftHeader.widthAnchor).isActive = true
        scrollKeyView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        
        scrollView = UIScrollView(frame: frame)
        scrollView.contentSize = gridBackground.bounds.size
        scrollView.maximumZoomScale = 3.0
        scrollView.minimumZoomScale = 1.0
        scrollView.delegate = self
        scrollView.addSubview(gridBackground)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scrollView)
        
        scrollView.leftAnchor.constraint(equalTo: scrollKeyView.rightAnchor).isActive = true
//        scrollView.leadingAnchor.constraint(equalTo: scrollKeyView.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor   ).isActive = true
        
        drawGrid()
    }
    
    func getGridBounds() {
        //MARK: 나중에 type 을 enum으로 비교해서 로직 분리하는걸... 찾아보기
        let typeProperties = TYPE_PIANO.self
        print("gridBackground size > width:\(typeProperties.getWidth), height:\(typeProperties.getHeight)")
        gridBackgroundBounds = CGRect(x: 0, y: 0, width: typeProperties.getWidth, height: typeProperties.getHeight)
    }
    
    func drawGrid() {
        //MARK: 나중에 type 을 enum으로 비교해서 로직 분리하는걸... 찾아보기
        let typeProperties = TYPE_PIANO.self
        
        var xPosition: CGFloat = 0
        for _ in 0 ..< typeProperties.cols.rawValue {

            xPosition += CGFloat(typeProperties.WHITEKEY_SIZE.rawValue)
            
            let line = CAShapeLayer()
            let path = UIBezierPath()
            path.move(to: CGPoint(x: xPosition, y: 0 + gridBoundMargin))
            path.addLine(to: CGPoint(x: xPosition , y: gridBackgroundBounds.height + gridBoundMargin ))
            line.path = path.cgPath
            line.strokeColor = UIColor.black.cgColor
            line.lineWidth = 1
            gridBackground.layer.addSublayer(line)
        }
        
        var yPosition: CGFloat = gridBackgroundBounds.height
        for row in 0 ..< typeProperties.rows.rawValue {
            let yPoint = TYPE_PIANO_NOTE_SCALE_HEIGHT[row % TYPE_PIANO_NOTE_SCALE_HEIGHT.count]
            yPosition -= CGFloat(yPoint)

            let line = CAShapeLayer()
            let path = UIBezierPath()
            //헤더부분까지 같이 그려줌...
            path.move(to: CGPoint(x: 0, y: yPosition + gridBoundMargin))
            path.addLine(to: CGPoint(x: gridBackgroundBounds.width , y: yPosition + gridBoundMargin))
            line.path = path.cgPath
            line.strokeColor = UIColor.black.cgColor
            line.lineWidth = 1
            gridBackground.layer.addSublayer(line)
        }
    }
    
    func drawHeader() {
        //MARK: 나중에 type 을 enum으로 비교해서 로직 분리하는걸... 찾아보기
        let typeProperties = TYPE_PIANO.self
     
        //흰건반
        var yPosition: CGFloat = gridBackgroundBounds.height
        for row in 0 ..< typeProperties.totOctave.rawValue * TYPE_PIANO_NOTE_WHITE_SCALE_HEIGHT.count {
            let yPoint = TYPE_PIANO_NOTE_WHITE_SCALE_HEIGHT[row % TYPE_PIANO_NOTE_WHITE_SCALE_HEIGHT.count]
            yPosition -= CGFloat(yPoint)

            let whiteNote = CALayer()
            whiteNote.backgroundColor = UIColor.white.cgColor
            let borderRect = CGRect(x: gridBoundMargin, y: gridBoundMargin + yPosition, width: CGFloat(60.0), height: CGFloat(yPoint))
            whiteNote.frame = borderRect

            gridLeftHeader.layer.addSublayer(whiteNote)
            
            let border = CALayer()
            border.backgroundColor = UIColor.gray.cgColor
            border.frame = CGRect(x: borderRect.minX, y: borderRect.minY, width: borderRect.width, height: 1)
            gridLeftHeader.layer.addSublayer(border)

            let noteLabel = ONCATextLayer()
            noteLabel.fontSize = 13
            noteLabel.string = combineNoteLabel(row: row)
            noteLabel.foregroundColor = UIColor.black.cgColor
            noteLabel.frame = CGRect(x: gridBoundMargin + (gridHeaderWidth / 2), y: gridBoundMargin + yPosition, width: CGFloat(30.0), height: CGFloat(yPoint))
            noteLabel.alignmentMode = kCAAlignmentCenter
            gridLeftHeader.layer.addSublayer(noteLabel)

        }
        
        //검은건반
        yPosition = gridBackgroundBounds.height
        for row in 0 ..< typeProperties.totOctave.rawValue * TYPE_PIANO_NOTE_BLACK_SCALE_HEIGHT.count {
            let yPoint = TYPE_PIANO_NOTE_BLACK_SCALE_HEIGHT[row % TYPE_PIANO_NOTE_BLACK_SCALE_HEIGHT.count]
            yPosition -= CGFloat(yPoint)
            
            let blackNote = CALayer()
            blackNote.backgroundColor = yPoint == 20 ? UIColor.black.cgColor : UIColor.clear.cgColor
            let blackNoteBounds = CGRect(x: gridBoundMargin, y: gridBoundMargin + yPosition, width: CGFloat(30.0), height: CGFloat(yPoint))
            blackNote.frame = blackNoteBounds
            
            gridLeftHeader.layer.addSublayer(blackNote)
            
        }

    }
    
    func combineNoteLabel(row: Int) -> String {
        let noteText = TYPE_PIANO_NOTE_SCALE_TEXT[row % TYPE_PIANO_NOTE_SCALE_TEXT.count]
        let octaveText = CGFloat(row / TYPE_PIANO_NOTE_WHITE_SCALE_HEIGHT.count).rounded(.down)
        return noteText + String(describing: Int(octaveText) + 1)
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func handleTapGesture(recognizer: UITapGestureRecognizer) {
        //MARK: 나중에 type 을 enum으로 비교해서 로직 분리하는걸... 찾아보기
        let typeProperties = TYPE_PIANO.self
        
        let touchLocationView = recognizer.location(in: self.grid)
        let touchLocation = recognizer.location(in: self)
        
        if self.grid.frame.contains(touchLocation) {
            
            var posX: CGFloat = touchLocationView.x / CGFloat(typeProperties.WHITEKEY_SIZE.rawValue)
            posX.round(.down)
            var posY: CGFloat = touchLocationView.y

            let rectX = touchLocationView.x - touchLocationView.x.truncatingRemainder(dividingBy: CGFloat(typeProperties.WHITEKEY_SIZE.rawValue))
            var rectY = 0
            var rectHeight = 0

            if posY / 190 < 1 {
                for idx in 0 ..< TYPE_PIANO_NOTE_SCALE_HEIGHT_REVERSED.count {
                    posY -= CGFloat(TYPE_PIANO_NOTE_SCALE_HEIGHT_REVERSED[idx])
                    if( posY < 0) {
                        if idx <= 0 {
                            rectY = 0
                            rectHeight = 20
                        } else {
                            
                            rectY = Int(touchLocationView.y - (posY + CGFloat(TYPE_PIANO_NOTE_SCALE_HEIGHT_REVERSED[idx])))
                            rectHeight = TYPE_PIANO_NOTE_SCALE_HEIGHT_REVERSED[idx]
                        }
                        
                        posY = CGFloat(idx)
                        break
                    }
                }
                
            } else {
                let additionalPosY = CGFloat(posY / 190).rounded(.down)
                var remainPosY = posY.truncatingRemainder(dividingBy: 190)
                
                for idx in 0 ..< TYPE_PIANO_NOTE_SCALE_HEIGHT_REVERSED.count {
                    remainPosY -= CGFloat(TYPE_PIANO_NOTE_SCALE_HEIGHT_REVERSED[idx])
                    if( remainPosY < 0) {
                        rectY = Int(touchLocationView.y - (remainPosY + CGFloat(TYPE_PIANO_NOTE_SCALE_HEIGHT_REVERSED[idx])))
                        rectHeight = TYPE_PIANO_NOTE_SCALE_HEIGHT_REVERSED[idx]
                        posY = CGFloat(idx) + (additionalPosY * CGFloat(TYPE_PIANO_NOTE_SCALE_HEIGHT_REVERSED.count))
                        break
                    }
                }
            }
            
            
            
            //인덱스는...?
            let curIdx = (posY * CGFloat(typeProperties.cols.rawValue)) + posX
            print("posX : \(posX), posY : \(posY), curIdx : \(curIdx), rectX : \(rectX), rectY : \(rectY), isMarking : \(isMarking)")

            if isMarking {
                //마킹하기
                if notes[Int(curIdx)] != nil {
                    print("[WARNING!] 이미 마킹한 코드가 있어용")
                    return
                }
                
                drawRect(idx: Int(curIdx), rect: CGRect(x: rectX, y: CGFloat(rectY), width: CGFloat(typeProperties.WHITEKEY_SIZE.rawValue), height: CGFloat(rectHeight)))
            } else {
                //마킹된거 지우기
                guard let selectedLayer = notes[Int(curIdx)] else {
                    print("[WARNING!] 저장된 마크가 없어용")
                    return
                }
                
                guard let selectedLayerIdx = grid.layer.sublayers?.index(of: selectedLayer) else {
                    print("[WARNING!] 저장된 마크가 없으니 그려진 레이어도 없겠져....")
                    return
                }
                self.grid.layer.sublayers?.remove(at: selectedLayerIdx)
                notes.removeValue(forKey: Int(curIdx))
            }
            
        }

    }
    
    func drawRect(idx: Int, rect: CGRect) {
        let circleLayer = CALayer()
        circleLayer.backgroundColor = UIColor.blue.cgColor
        circleLayer.frame = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width, height: rect.size.height)
        self.grid.layer.addSublayer(circleLayer)
        self.notes[Int(idx)] = circleLayer
    }
 
    
}

extension GridView: UIScrollViewDelegate {
    
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if scrollView == self.scrollView {
            return gridBackground
        } else  {
            return gridLeftHeader
        }
    }
    
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
            if scrollView == self.scrollView {
                print("normal - 그리드")
                synchronizeScrollView(scrollKeyView, toScrollView: self.scrollView)
            } else if scrollView == scrollKeyView {
                print("normal - 헤더")
                //양쪽에서 스크롤이 발생하니까..... 꼬여
                synchronizeScrollView(self.scrollView, toScrollView: scrollKeyView)
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
        if scrollView == self.scrollView {
            scrollKeyView.setZoomScale(scale, animated: true)
//            scrollViewWillBeginDragging(self.scrollView)
//            scrollViewDidScroll(self.scrollView )
        } else if scrollView == scrollKeyView {
            self.scrollView.setZoomScale(scale, animated: true)
//            scrollViewWillBeginDragging(scrollKeyView)
//            scrollViewDidScroll(scrollKeyView)
        }
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        if scrollView == self.scrollView {

//        } else {
            print("zoom ... view > width:\(gridLeftHeader.frame.width), height:\(gridLeftHeader.frame.height)")
            scrollKeyView.frame = CGRect(x: 0, y: 0, width: gridLeftHeader.frame.width, height: gridLeftHeader.frame.height)
            
            let originalRect = self.scrollView.frame
            print("original scrollView > x:\(self.scrollView.frame.origin.x), y:\(self.scrollView.frame.origin.y), width:\(self.scrollView.frame.size.width), height:\(self.scrollView.frame.size.height)")
            
            let diff = gridLeftHeader.frame.width - originalRect.origin.x
            self.scrollView.frame = CGRect(x: originalRect.origin.x + diff, y: 0, width: originalRect.size.width - diff, height: originalRect.size.height)
//            print("original offset > x:\(self.scrollView.contentOffset.x), y:\(self.scrollView.contentOffset.y)")
//            self.scrollView.frame = CGRect(x: gridLeftHeader.frame.width, y: 0, width: self.scrollView.frame.size.width - gridLeftHeader.frame.width, height: self.scrollView.frame.size.height)
//        }
    }

}

extension GridView: NoteGridViewDelegate {
    
    func play() {
        let cols = TYPE_PIANO.cols.rawValue
        
        var dat: [Int:String] = [:]
        
        notes.forEach { (key, value) in
            dat[key] = String(format: "%03d", Int(CGFloat(key / cols).rounded(.down)))
            
        }

        timeline.buildSoundArray(size: notes.count, notes: dat)
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
            print("index:\(parsed[0]), x:\(parsed[1]), y:\(parsed[2]), width:\(parsed[3]), height\(parsed[4])")
 
            let x = CGFloat(truncating: NumberFormatter().number(from: String(parsed[1]))!)
            let y = CGFloat(truncating: NumberFormatter().number(from: String(parsed[2]))!)
            let width = CGFloat(truncating: NumberFormatter().number(from: String(parsed[3]))!)
            let height = CGFloat(truncating: NumberFormatter().number(from: String(parsed[4]))!)
            
            drawRect(idx: Int(parsed[0])!, rect: CGRect(x: x, y: y, width: width, height: height))
        }
    }
    
    
    //MARK: 오래걸리면.. indicator 같은거
    func save(fileName: String) {
        guard fileName != "" else {
            gridDelegate?.warning(message: "파일명이 제대로 입력되지 않아서 저장 할 수 없습니다")
            return
        }
        
        var saveContents: String = ""
        
        notes.forEach { (key, value) in
            let rect = value.frame

            //index,x,y,width,height
            saveContents = saveContents.appendingFormat("%d,%f,%f,%f,%f\n", key, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
        }
        let fileManager = ONFileManager()
        fileManager.saveToDatFileSeparatedCR(fileName: fileName, contents: saveContents)
        
        //MARK: ENUM 타입을 넣을 수 없음.. 일단 문자열 하드코딩
        UserDefaults.standard.set("PIANO", forKey: fileName)
        print("save > key:\(fileName)")
        
        gridDelegate?.alert(message: "저장 완료")
    }
    
}

extension GridView: NoteMenuDelegate {
    func markingStatusChanged(isMark: Bool) {
        isMarking = isMark
    }
}


