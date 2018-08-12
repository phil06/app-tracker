//
//  GridView.swift
//  TRACKER
//
//  Created by NHNEnt on 2018. 8. 8..
//  Copyright © 2018년 OnlyNew. All rights reserved.
//

import UIKit

//MARK: 여백을 만드려고 30씩 더한거.. 리펙토링 하기..
class GridView: UIView {
    
    var notes:[Int:CALayer] = [Int:CALayer] ()
    
    var type: InstrumentKind?
    
    let circleWidth: CGFloat = 20

    var gridBackgroundBounds: CGRect!
    
    var originTouchLocation: CGPoint!
    var originViewCenter: CGPoint!
    
    var scrollView: UIScrollView!
    var gridBackground: UIView!
    var grid: UIView!
    
    var isMarking: Bool!

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.isUserInteractionEnabled = true

        self.backgroundColor = UIColor.black

        getGridBounds()
        
        grid = UIView(frame: CGRect(x: 30, y: 30, width: gridBackgroundBounds.width, height: gridBackgroundBounds.height))
        grid.backgroundColor = UIColor.clear
        
        gridBackground = UIView(frame: CGRect(x: 0, y: 0, width: gridBackgroundBounds.width + 60, height: gridBackgroundBounds.height + 60))
        gridBackground.backgroundColor = UIColor.white
        gridBackground.addSubview(grid)
        
        scrollView = UIScrollView(frame: frame)
        scrollView.contentSize = gridBackground.bounds.size
        scrollView.maximumZoomScale = 3.0
        scrollView.minimumZoomScale = 1.0
        scrollView.delegate = self
        scrollView.addSubview(gridBackground)
        
        
        
//        scrollView.addSubview(grid)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scrollView)
        
        scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

        drawGrid()
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
            xPosition += CGFloat(typeProperties.WHITEKEY_SIZE.rawValue + 1)
            
            let line = CAShapeLayer()
            let path = UIBezierPath()
            path.move(to: CGPoint(x: xPosition + 30, y: 0 + 30))
            path.addLine(to: CGPoint(x: xPosition + 30, y: gridBackgroundBounds.height + 30 ))
            line.path = path.cgPath
            line.strokeColor = UIColor.black.cgColor
            line.lineWidth = 1
            gridBackground.layer.addSublayer(line)
        }
        
        //MARK: 얘.. 거꾸로 표시되야해.. 위에서 아래가 아니라 아래에서 위로..
        var yPosition: CGFloat = gridBackgroundBounds.height
        for row in 0 ..< typeProperties.rows.rawValue {
            let yPoint = TYPE_PIANO_NOTE_SCALE_HEIGHT[row % TYPE_PIANO_NOTE_SCALE_HEIGHT.count] + 1
            yPosition -= CGFloat(yPoint)
            print("yPoint : \(yPoint), yPosition:\(yPosition)")
            let line = CAShapeLayer()
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 0 + 30, y: yPosition + 30))
            path.addLine(to: CGPoint(x: gridBackgroundBounds.width + 30, y: yPosition + 30))
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
            

            
            //계산땜에 글치.. Float 일 필요없음
            //1을 더해준건... 선 때문에.. 뒤로갈수록 밀려서..
            var posX: CGFloat = touchLocationView.x / CGFloat(typeProperties.WHITEKEY_SIZE.rawValue + 1)
            posX.round(.down)
            var posY: CGFloat = touchLocationView.y
            //위치 / 201(한 옥타브 음계 배열의 총 길이) 하면 옥타브 위치는 알 수 있음
            
            let rectX = Int(touchLocationView.x - touchLocationView.x.truncatingRemainder(dividingBy: CGFloat(typeProperties.WHITEKEY_SIZE.rawValue + 1)))
            var rectY = 0
            var rectHeight = 0
            var rectWidth = 0
            
            if posY / 201 < 1 {
                for idx in 0 ..< TYPE_PIANO_NOTE_SCALE_HEIGHT_REVERSED.count {
                    posY -= CGFloat(TYPE_PIANO_NOTE_SCALE_HEIGHT_REVERSED[idx] + 1)
                    if( posY < 0) {
                        if idx <= 0 {
                            rectY = 0
                            rectHeight = 20
                        } else {
                            print("여긴 절대 안탈거같은데...")
                            rectY = Int(touchLocationView.y - CGFloat(TYPE_PIANO_NOTE_SCALE_HEIGHT_REVERSED[idx-1] + 1))
                            rectHeight = TYPE_PIANO_NOTE_SCALE_HEIGHT_REVERSED[idx-1]
                        }
                        
                        posY = CGFloat(idx)
                        break
                    }
                }
                
            } else {
                let additionalPosY = CGFloat(posY / 201).rounded(.down)
                var remainPosY = posY.truncatingRemainder(dividingBy: 201)
                
                for idx in 0 ..< TYPE_PIANO_NOTE_SCALE_HEIGHT_REVERSED.count {
                    remainPosY -= CGFloat(TYPE_PIANO_NOTE_SCALE_HEIGHT_REVERSED[idx] + 1)
                    if( remainPosY < 0) {
                        rectY = Int(touchLocationView.y - CGFloat(TYPE_PIANO_NOTE_SCALE_HEIGHT_REVERSED[idx] + 1))
                        rectHeight = TYPE_PIANO_NOTE_SCALE_HEIGHT_REVERSED[idx-1]
                        posY = CGFloat(idx) + additionalPosY
                        break
                    }
                }
            }
            
            
            
            //인덱스는...?
            let curIdx = (posY * CGFloat(typeProperties.cols.rawValue)) + posX
            print("posX : \(posX), posY : \(posY), curIdx : \(curIdx), rectX : \(rectX), rectY : \(rectY), isMarking : \(isMarking)")
            print("")

            if isMarking {
                //마킹하기
                if notes[Int(curIdx)] != nil {
                    print("[WARNING!] 이미 마킹한 코드가 있어용")
                    return
                }
                
                let circleLayer = CALayer()
                circleLayer.backgroundColor = UIColor.blue.cgColor
//                circleLayer.fillColor = UIColor.black.cgColor
                circleLayer.frame = CGRect(x: rectX, y: rectY, width: typeProperties.WHITEKEY_SIZE.rawValue, height: rectHeight)
//                circleLayer.path = UIBezierPath(rect:
//                    CGRect(x:touchLocationView.x - (circleWidth/2), y:touchLocationView.y - (circleWidth/2),
//                           width:circleWidth, height:circleWidth)).cgPath
//                circleLayer.path = UIBezierPath(rect: CGRect(x: rectX + 1, y: rectY, width: typeProperties.WHITEKEY_SIZE.rawValue, height: typeProperties.WHITEKEY_SIZE.rawValue)).cgPath
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

extension GridView: NoteMenuDelegate {
    func markingStatusChanged(isMark: Bool) {
        isMarking = isMark

    }
}


