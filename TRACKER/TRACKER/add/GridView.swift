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
    var gridBackground: UIView!
    var grid: UIView!
    
    var isMarking: Bool!
    
    weak var gridDelegate: GridDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.isUserInteractionEnabled = true
        self.backgroundColor = UIColor.black

        getGridBounds()
        
        grid = UIView(frame: CGRect(x: gridBoundMargin + gridHeaderWidth, y: gridBoundMargin, width: gridBackgroundBounds.width, height: gridBackgroundBounds.height))
        grid.backgroundColor = UIColor.clear
        grid.layer.borderWidth = 1
        grid.layer.borderColor = UIColor.black.cgColor
        
        gridBackground = UIView(frame: CGRect(x: 0, y: 0, width: gridBackgroundBounds.width + (gridBoundMargin * 2) + gridHeaderWidth, height: gridBackgroundBounds.height + (gridBoundMargin * 2)))
        gridBackground.backgroundColor = UIColor.white
        gridBackground.addSubview(grid)
        
        scrollView = UIScrollView(frame: frame)
        scrollView.contentSize = gridBackground.bounds.size
        scrollView.maximumZoomScale = 3.0
        scrollView.minimumZoomScale = 1.0
        scrollView.delegate = self
        scrollView.addSubview(gridBackground)
      
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scrollView)
        
        scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

        drawGrid()
        
        drawHeader()
    }
    
    func getGridBounds(){
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
            path.move(to: CGPoint(x: xPosition + gridBoundMargin + gridHeaderWidth, y: 0 + gridBoundMargin))
            path.addLine(to: CGPoint(x: xPosition + gridBoundMargin + gridHeaderWidth, y: gridBackgroundBounds.height + gridBoundMargin ))
            line.path = path.cgPath
            line.strokeColor = UIColor.black.cgColor
            line.lineWidth = 1
            gridBackground.layer.addSublayer(line)
        }
        
        var yPosition: CGFloat = gridBackgroundBounds.height
        for row in 0 ..< typeProperties.rows.rawValue {
            let yPoint = TYPE_PIANO_NOTE_SCALE_HEIGHT[row % TYPE_PIANO_NOTE_SCALE_HEIGHT.count]
            yPosition -= CGFloat(yPoint)
            print("yPoint : \(yPoint), yPosition:\(yPosition)")
            let line = CAShapeLayer()
            let path = UIBezierPath()
            //헤더부분까지 같이 그려줌...
            path.move(to: CGPoint(x: gridBoundMargin + gridHeaderWidth, y: yPosition + gridBoundMargin))
            path.addLine(to: CGPoint(x: gridBackgroundBounds.width + gridBoundMargin + gridHeaderWidth, y: yPosition + gridBoundMargin))
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
            //MARK: 왜 이 함수안에선 선이 안그어졌을까..?
//            addBorder(toSide: ViewSide.Top, withColor: UIColor.gray.cgColor, andThickness: 1, frame: borderRect)
            gridBackground.layer.addSublayer(whiteNote)
            
            let border = CALayer()
            border.backgroundColor = UIColor.gray.cgColor
            border.frame = CGRect(x: borderRect.minX, y: borderRect.minY, width: borderRect.width, height: 1)
            gridBackground.layer.addSublayer(border)
            
            let noteText = TYPE_PIANO_NOTE_SCALE_TEXT[row % TYPE_PIANO_NOTE_SCALE_TEXT.count]
            let octaveText = CGFloat(row / TYPE_PIANO_NOTE_WHITE_SCALE_HEIGHT.count).rounded(.down)
            
            let noteLabel = ONCATextLayer()
            noteLabel.fontSize = 13
            noteLabel.string =  noteText + String(describing: Int(octaveText) + 1)
            noteLabel.foregroundColor = UIColor.black.cgColor
            noteLabel.frame = CGRect(x: gridBoundMargin + (gridHeaderWidth / 2), y: gridBoundMargin + yPosition, width: CGFloat(30.0), height: CGFloat(yPoint))
            noteLabel.alignmentMode = kCAAlignmentCenter
            gridBackground.layer.addSublayer(noteLabel)

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
            
            gridBackground.layer.addSublayer(blackNote)
            
        }

    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func handleTapGesture(recognizer: UITapGestureRecognizer) {
        //MARK: 나중에 type 을 enum으로 비교해서 로직 분리하는걸... 찾아보기
        let typeProperties = TYPE_PIANO.self
        
        let touchLocationView = recognizer.location(in: self.grid)
        let touchLocation = recognizer.location(in: self)
        
        print("gird touchLoc > x:\(touchLocationView.x), y:\(touchLocationView.y)")
        print("self touchLoc > x:\(touchLocation.x), y:\(touchLocation.y)")
        
        if self.grid.frame.contains(touchLocation) {
            
            print("touchLocation is tabbed in grid Area!")
     
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
                
                let circleLayer = CALayer()
                circleLayer.backgroundColor = UIColor.blue.cgColor

                print("draw rect > x:\(rectX), y:\(rectY), width:\(typeProperties.WHITEKEY_SIZE.rawValue), height:\(rectHeight)")
                circleLayer.frame = CGRect(x: rectX, y: CGFloat(rectY), width: CGFloat(typeProperties.WHITEKEY_SIZE.rawValue), height: CGFloat(rectHeight))

                self.grid.layer.addSublayer(circleLayer)
                self.notes[Int(curIdx)] = circleLayer
                
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
    
    
    
}

extension GridView: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return gridBackground
    }
}

extension GridView: NoteGridViewDelegate {
    
    //MARK: 오래걸리면.. indicator 같은거
    func save(fileName: String) {
        guard fileName != "" else {
            gridDelegate?.warning(message: "파일명이 제대로 입력되지 않아서 저장 할 수 없습니다")
            return
        }
        
        let saveContents: String = ""
        
        notes.forEach { (key, value) in
            let rect = value.frame
            print("key : \(key), value : \(value)")
            print("value rect > x:\(rect.origin.x), y:\(rect.origin.y), width:\(rect.size.width), height:\(rect.size.height)")
            //index,x,y,width,height
            saveContents.appendingFormat("%d,%d,%d,%d,%d\n", key, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
        }
        let fileManager = ONFileManager()
        fileManager.saveToDatFileSeparatedCR(fileName: fileName, contents: saveContents)
    }
    
}

extension GridView: NoteMenuDelegate {
    func markingStatusChanged(isMark: Bool) {
        isMarking = isMark
    }
}


//// This syntax reflects changes made to the Swift language as of Aug. '16
//extension GridView {
//
//    // Example use: myView.addBorder(toSide: .Left, withColor: UIColor.redColor().CGColor, andThickness: 1.0)
//    enum ViewSide {
//        case Left, Right, Top, Bottom
//    }
//
//    func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat, frame: CGRect) {
//
//        let border = CALayer()
//        border.backgroundColor = color
//
//        switch side {
//        case .Left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height); break
//        case .Right: border.frame = CGRect(x: frame.maxX, y: frame.minY, width: thickness, height: frame.height); break
//        case .Top: border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness); break
//        case .Bottom: border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness); break
//        }
//
//        print("addBorder > x:\(frame.minX), y:\(frame.minY), width:\(frame.width), height:\(thickness)")
//
//        gridBackground.layer.addSublayer(border)
//    }
//
//}


