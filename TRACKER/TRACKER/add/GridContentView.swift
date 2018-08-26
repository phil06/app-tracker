//
//  GridContentView.swift
//  TRACKER
//
//  Created by NHNEnt on 2018. 8. 24..
//  Copyright © 2018년 OnlyNew. All rights reserved.
//

import UIKit

class GridContentView: UIView {
    
    //MARK: 일단..
    let typeProperties = TYPE_PIANO.self
    
    var scrollView: UIScrollView!
    
    var gridBackground: UIView!
    var grid: UIView!
    
    var isMarking: Bool!
    var notes:[Int:CALayer] = [Int:CALayer] ()
    
    var currentScrollY: CGFloat = 0
    
    weak var gridViewDelegate: GridViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        grid = UIView(frame: CGRect(x: 0, y: ADD_GRID_LEFT_HEADER_MARGIN, width: CGFloat(typeProperties.getWidth), height: CGFloat(typeProperties.getHeight)))
        grid.backgroundColor = UIColor.clear
        grid.layer.borderWidth = 1
        grid.layer.borderColor = UIColor.black.cgColor
        
        gridBackground = UIView(frame: CGRect(x: 0, y: 0, width: CGFloat(typeProperties.getWidth) + ADD_GRID_LEFT_HEADER_MARGIN, height: CGFloat(typeProperties.getHeight) + (ADD_GRID_LEFT_HEADER_MARGIN * 2)))
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
        
        
        var xPosition: CGFloat = 0
        for _ in 0 ..< typeProperties.cols.rawValue {
            xPosition += CGFloat(typeProperties.WHITEKEY_SIZE.rawValue)
            
            let line = CAShapeLayer()
            let path = UIBezierPath()
            path.move(to: CGPoint(x: xPosition, y: 0 + ADD_GRID_LEFT_HEADER_MARGIN))
            path.addLine(to: CGPoint(x: xPosition , y: grid.frame.height + ADD_GRID_LEFT_HEADER_MARGIN ))
            line.path = path.cgPath
            line.strokeColor = UIColor.black.cgColor
            line.lineWidth = 1
            gridBackground.layer.addSublayer(line)
        }
        
        var yPosition: CGFloat = gridBackground.frame.height - ADD_GRID_LEFT_HEADER_MARGIN
        for row in 0 ..< typeProperties.rows.rawValue {
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
        grid.layer.addSublayer(circleLayer)
        notes[Int(idx)] = circleLayer
    }
    
}

extension GridContentView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return gridBackground
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        gridViewDelegate?.synchronizeScrollViewZoom(scale: scrollView.zoomScale)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var curOffset = scrollView.contentOffset
        curOffset.y = currentScrollY
        self.scrollView.contentOffset = curOffset
    }
}

extension GridContentView: NoteMenuDelegate {
    func markingStatusChanged(isMark: Bool) {
        isMarking = isMark
    }
}
