//
//  GridView.swift
//  TRACKER
//
//  Created by NHNEnt on 2018. 8. 8..
//  Copyright © 2018년 OnlyNew. All rights reserved.
//

import UIKit

class GridView: UIView {
    
    let circleWidth: CGFloat = 20
    let viewWidth: CGFloat = 1000
    let viewHeight: CGFloat = 1000
    
    var originTouchLocation: CGPoint!
    var originViewCenter: CGPoint!
    
    var scrollView: UIScrollView!
    var gridBackground: UIView!
    
    weak var delegate: NoteMenuDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = true
        
        self.backgroundColor = UIColor.black
        
        gridBackground = UIView(frame: CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight))
        gridBackground.backgroundColor = UIColor.white
        
        scrollView = UIScrollView(frame: CGRect(origin: CGPoint.zero, size: self.frame.size))
        scrollView.contentSize = gridBackground.bounds.size
        scrollView.addSubview(gridBackground)
        self.addSubview(scrollView)
        
        delegate?.changeMarkingStatus()
        
        
        
//        self.addSubview(gridBackground)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func handleTapGesture(recognizer: UITapGestureRecognizer) {
        let touchLocationView = recognizer.location(in: self.gridBackground)
        let touchLocation = recognizer.location(in: self)
        
        print("touchLocation > x:\(touchLocation.x), y:\(touchLocation.y)")
        print("touchLocationView > x:\(touchLocationView.x), y:\(touchLocationView.y)")
 
        if self.gridBackground.frame.contains(touchLocation) {
            print("grid view in")
            
            let circleLayer = CAShapeLayer()
            circleLayer.fillColor = UIColor.black.cgColor
            circleLayer.path = UIBezierPath(ovalIn: CGRect(x:touchLocationView.x - (circleWidth/2), y:touchLocationView.y - (circleWidth/2), width:circleWidth, height:circleWidth)).cgPath
            
            self.gridBackground.layer.addSublayer(circleLayer)
        } else {
            print("not in grid view")
        }

    }
    
}

extension GridView: NoteMenuDelegate {
    
}



