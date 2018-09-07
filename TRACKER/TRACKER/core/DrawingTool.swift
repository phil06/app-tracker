//
//  DrawingTool.swift
//  TRACKER
//
//  Created by NHNEnt on 2018. 9. 3..
//  Copyright © 2018년 OnlyNew. All rights reserved.
//

import UIKit

class DrawingTool {
    
    func grid(view: inout UIView, type: InstrumentType) {
        
        
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
            view.layer.addSublayer(line)
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
            view.layer.addSublayer(line)
        }
    }
}
