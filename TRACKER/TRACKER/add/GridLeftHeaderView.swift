//
//  GridLeftHeaderPianoView.swift
//  TRACKER
//
//  Created by NHNEnt on 2018. 8. 24..
//  Copyright © 2018년 OnlyNew. All rights reserved.
//

import UIKit

class GridLeftHeaderView: UIView {
    
    var type: InstrumentType!

    var leftHeader: UIView!
    var scrollView: UIScrollView!
    
    weak var gridViewDelegate: GridViewDelegate?
    
    init(frame: CGRect, type: InstrumentType) {

        super.init(frame: frame)
        
        self.type = type
        self.backgroundColor = UIColor.white
        leftHeader = UIView(frame: CGRect(x: 0, y: 0, width: type.getHeaderWidth(), height: CGFloat(type.getHeight() + (type.margin * 2))))
        
        draw()
        
        scrollView = UIScrollView()
        scrollView.contentSize = leftHeader.bounds.size
        scrollView.maximumZoomScale = 3.0
        scrollView.minimumZoomScale = 1.0
        scrollView.delegate = self
        scrollView.addSubview(leftHeader)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isDirectionalLockEnabled = true
        scrollView.showsVerticalScrollIndicator = false

        self.addSubview(scrollView)
        
        scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: leftHeader.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    func combineNoteLabel(row: Int) -> String {
        let noteText = TYPE_PIANO_NOTE_SCALE_TEXT[row % TYPE_PIANO_NOTE_SCALE_TEXT.count]
        let octaveText = CGFloat(row / TYPE_PIANO_NOTE_WHITE_SCALE_HEIGHT.count).rounded(.down)
        return noteText + String(describing: Int(octaveText) + 1)
    }
    
    func draw() {
        
        switch type.type {
        case InstrumentKind.PIANO:
            drawPianoHeader()
        case InstrumentKind.DRUM:
            drawDrum()
        default:
            print("으응 없어어~")
        }

    }
    
    private func drawDrum() {
        
        var yPosition: CGFloat = CGFloat(type.getHeight())
        for row in 0 ..< TYPE_DRUM_NOTE_ICON.count * type.totOctave {
            yPosition -= CGFloat(type.gridSize)

            let iconImage = CALayer()
            iconImage.frame = CGRect(x: 0, y: CGFloat(type.margin) + yPosition, width: CGFloat(type.gridSize), height: CGFloat(type.gridSize))
            iconImage.contents = UIImage(named: TYPE_DRUM_NOTE_ICON[row])?.cgImage
            iconImage.borderWidth = 1
            iconImage.borderColor = UIColor.black.cgColor
            
            leftHeader.layer.addSublayer(iconImage)
            
            print(row)
        }
    }
    
    private func drawPianoHeader() {
        //흰건반
        var yPosition: CGFloat = CGFloat(type.getHeight())
        for row in 0 ..< type.totOctave * TYPE_PIANO_NOTE_WHITE_SCALE_HEIGHT.count {
            let yPoint = TYPE_PIANO_NOTE_WHITE_SCALE_HEIGHT[row % TYPE_PIANO_NOTE_WHITE_SCALE_HEIGHT.count]
            yPosition -= CGFloat(yPoint)
            
            let whiteNote = CALayer()
            whiteNote.backgroundColor = UIColor.white.cgColor
            let borderRect = CGRect(x: 0, y: CGFloat(type.margin) + yPosition, width: CGFloat(60.0), height: CGFloat(yPoint))
            whiteNote.frame = borderRect
            
            leftHeader.layer.addSublayer(whiteNote)
            
            let border = CALayer()
            border.backgroundColor = UIColor.gray.cgColor
            border.frame = CGRect(x: borderRect.minX, y: borderRect.minY, width: borderRect.width, height: 1)
            leftHeader.layer.addSublayer(border)
            
            let noteLabel = ONCATextLayer()
            noteLabel.fontSize = 13
            noteLabel.string = combineNoteLabel(row: row)
            noteLabel.foregroundColor = UIColor.black.cgColor
            noteLabel.frame = CGRect(x: CGFloat(type.headerWidth / 2), y: CGFloat(type.margin) + yPosition, width: CGFloat(30.0), height: CGFloat(yPoint))
            noteLabel.alignmentMode = kCAAlignmentCenter
            leftHeader.layer.addSublayer(noteLabel)
            
        }
        
        //검은건반
        yPosition = CGFloat(type.getHeight())
        for row in 0 ..< type.totOctave * TYPE_PIANO_NOTE_BLACK_SCALE_HEIGHT.count {
            let yPoint = TYPE_PIANO_NOTE_BLACK_SCALE_HEIGHT[row % TYPE_PIANO_NOTE_BLACK_SCALE_HEIGHT.count]
            yPosition -= CGFloat(yPoint)
            
            let blackNote = CALayer()
            blackNote.backgroundColor = yPoint == Int(type.gridSize) ? UIColor.black.cgColor : UIColor.clear.cgColor
            let blackNoteBounds = CGRect(x: 0, y: CGFloat(type.margin) + yPosition, width: CGFloat(30.0), height: CGFloat(yPoint))
            blackNote.frame = blackNoteBounds
            
            leftHeader.layer.addSublayer(blackNote)
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension GridLeftHeaderView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return leftHeader

    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        gridViewDelegate?.synchronizeScrollViewZoom(scale: scrollView.zoomScale, scrollView: scrollView)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        gridViewDelegate?.synchronizeScrollViewY(pointY: scrollView.contentOffset.y)
    }
}
