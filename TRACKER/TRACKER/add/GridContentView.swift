//
//  GridContentView.swift
//  TRACKER
//
//  Created by NHNEnt on 2018. 8. 24..
//  Copyright © 2018년 OnlyNew. All rights reserved.
//

import UIKit

class GridContentView: UIView {

    var type: InstrumentType!
    
    var scrollView: UIScrollView!
    
    var gridBackground: UIView!
    var grid: UIView!
    
    var isMarking: Bool!
    var notes:[Int:CALayer] = [Int:CALayer] ()
    
    var currentScrollY: CGFloat = 0
    
    weak var gridViewDelegate: GridViewDelegate?
    
    init(frame: CGRect, type: InstrumentType) {
        super.init(frame: frame)
        
        self.type = type
        
        grid = UIView(frame: CGRect(x: 0, y: CGFloat(type.margin), width: CGFloat(type.getWidth()), height: CGFloat(type.getHeight())))
        grid.backgroundColor = UIColor.clear
        grid.layer.borderWidth = 1
        grid.layer.borderColor = UIColor.black.cgColor
        
        gridBackground = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat(type.getWidth()) + CGFloat(type.margin), height: CGFloat(type.getHeight() + (type.margin * 2))))
        gridBackground.backgroundColor = UIColor.white
        gridBackground.addSubview(grid)
        
        scrollView = UIScrollView()
        scrollView.contentSize = gridBackground.bounds.size
        scrollView.maximumZoomScale = 3.0
        scrollView.minimumZoomScale = 1.0
        scrollView.delegate = self
        scrollView.addSubview(gridBackground)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isDirectionalLockEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        self.addSubview(scrollView)
        
        scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        drawGrid()
        
        let taps = UITapGestureRecognizer(target: self, action:#selector(handleTapGesture(recognizer:)))
        self.addGestureRecognizer(taps)

        self.isUserInteractionEnabled = true
    }
    
    func drawGrid() {
        
        switch type.type {
        case InstrumentKind.PIANO:
            drawPianoGrid()
        case InstrumentKind.DRUM:
            drawDrum()
        default:
            print("으응 없어어~")
        }

        
    }
    
    func drawDrum() {
        var xPosition: CGFloat = 0
        for _ in 0 ..< type.cols {
            xPosition += CGFloat(type.gridSize)
            
            let line = CAShapeLayer()
            let path = UIBezierPath()
            path.move(to: CGPoint(x: xPosition, y: 0 + CGFloat(type.margin)))
            path.addLine(to: CGPoint(x: xPosition , y: grid.frame.height + CGFloat(type.margin) ))
            line.path = path.cgPath
            line.strokeColor = UIColor.black.cgColor
            line.lineWidth = 1
            gridBackground.layer.addSublayer(line)
        }
        
        var yPosition: CGFloat = gridBackground.frame.height - CGFloat(type.margin)
        for _ in 0 ..< type.rows * type.totOctave {
            yPosition -= CGFloat(type.gridSize)
            
            let line = CAShapeLayer()
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 0, y: yPosition))
            path.addLine(to: CGPoint(x: grid.frame.width , y: yPosition))
            line.path = path.cgPath
            line.strokeColor = UIColor.black.cgColor
            line.lineWidth = 1
            gridBackground.layer.addSublayer(line)
        }
    }
    
    func drawPianoGrid() {
        var xPosition: CGFloat = 0
        for _ in 0 ..< type.cols {
            xPosition += CGFloat(type.key2Size)
            
            let line = CAShapeLayer()
            let path = UIBezierPath()
            path.move(to: CGPoint(x: xPosition, y: 0 + CGFloat(type.margin)))
            path.addLine(to: CGPoint(x: xPosition , y: grid.frame.height + CGFloat(type.margin) ))
            line.path = path.cgPath
            line.strokeColor = UIColor.black.cgColor
            line.lineWidth = 1
            gridBackground.layer.addSublayer(line)
        }
        
        var yPosition: CGFloat = gridBackground.frame.height - CGFloat(type.margin)
        for row in 0 ..< type.rows {
            let yPoint = TYPE_PIANO_NOTE_SCALE_HEIGHT[row % TYPE_PIANO_NOTE_SCALE_HEIGHT.count]
            yPosition -= CGFloat(yPoint)
            
            let line = CAShapeLayer()
            let path = UIBezierPath()
            //헤더부분까지 같이 그려줌...
            path.move(to: CGPoint(x: 0, y: yPosition))
            path.addLine(to: CGPoint(x: grid.frame.width , y: yPosition))
            line.path = path.cgPath
            line.strokeColor = UIColor.black.cgColor
            line.lineWidth = 1
            gridBackground.layer.addSublayer(line)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func handleTapGesture(recognizer: UITapGestureRecognizer) {
        let touchLocationView = recognizer.location(in: self.grid)
        let touchLocation = recognizer.location(in: self)

        if self.grid.frame.contains(touchLocation) {

            var posX: CGFloat = touchLocationView.x / CGFloat(type.key2Size)
            posX.round(.down)
            var posY: CGFloat = touchLocationView.y

            let rectX = touchLocationView.x - touchLocationView.x.truncatingRemainder(dividingBy: CGFloat(type.key2Size))
            var rectY = 0
            var rectHeight = 0

            switch type.type {
            case .PIANO:
                if posY / 190 < 1 {
                    for idx in 0 ..< TYPE_PIANO_NOTE_SCALE_HEIGHT_REVERSED.count {
                        posY -= CGFloat(TYPE_PIANO_NOTE_SCALE_HEIGHT_REVERSED[idx])
                        if( posY < 0) {
                            if idx <= 0 {
                                rectY = 0
                                rectHeight = Int(type.gridSize)
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
                break
            case .DRUM:
                posY = touchLocationView.y / CGFloat(type.key2Size)
                posY.round(.down)
                rectHeight = Int(type.gridSize)
                rectY = Int(posY * CGFloat(type.gridSize))
                break
            case .GUITAR:
                
                break
            }
            



            //인덱스는...?
            let curIdx = (posY * CGFloat(type.cols)) + posX

            
            if isMarking {
                //마킹하기
                if notes[Int(curIdx)] != nil {
                    print("[WARNING!] 이미 마킹한 코드가 있어용")
                    return
                }

                drawRect(idx: Int(curIdx), rect: CGRect(x: rectX, y: CGFloat(rectY), width: CGFloat(type.key2Size), height: CGFloat(rectHeight)))
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
        grid.layer.addSublayer(circleLayer)
        notes[Int(idx)] = circleLayer
    }
    
}

extension GridContentView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return gridBackground
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        gridViewDelegate?.synchronizeScrollViewZoom(scale: scrollView.zoomScale, scrollView: scrollView)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var curOffset = scrollView.contentOffset
        curOffset.y = currentScrollY
        self.scrollView.contentOffset = curOffset
        
        let curPos = (scrollView.contentOffset.x / (CGFloat(type.gridSize) * scrollView.zoomScale)).rounded(.down)
        gridViewDelegate?.synchronizeSliderView(pos: curPos)
    }
}

extension GridContentView: NoteMenuDelegate {
    func markingStatusChanged(isMark: Bool) {
        isMarking = isMark
    }
}

