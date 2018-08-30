//
//  SeekBarSliderView.swift
//  TRACKER
//
//  Created by saera on 2018. 8. 26..
//  Copyright © 2018년 OnlyNew. All rights reserved.
//

import UIKit

class SeekBarSliderView: UIView {
    
    weak var seekBarDelegate: GridSeekBarDelegate?
    
    var mySlider: UISlider!
    var seekArrow: UIImageView!
    let arrowTopInset: CGFloat = 55
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        mySlider = UISlider(frame:CGRect.zero)
        mySlider.minimumValue = 0
        //MARK:
        mySlider.maximumValue = Float(TYPE_PIANO.cols.rawValue) - 1
        mySlider.isContinuous = true
        mySlider.tintColor = UIColor.green
        
        self.addSubview(mySlider)
        
        mySlider.addTarget(self, action: #selector(valueDidChange(_:)), for: .valueChanged)
        
        mySlider.translatesAutoresizingMaskIntoConstraints = false
        mySlider.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        mySlider.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        mySlider.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        mySlider.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        seekArrow = UIImageView(frame: CGRect(x: 0, y: arrowTopInset, width: CGFloat(ADD_GRID_ITEM_SIZE), height: CGFloat(ADD_GRID_ITEM_SIZE)))
        seekArrow.image = UIImage(named: "seek_bar_arrow.png")
        self.addSubview(seekArrow)
    }
    
    @objc func valueDidChange(_ sender:UISlider!) {
        let roundedValue = sender.value.rounded(.down)
        sender.value = roundedValue
        seekBarDelegate?.moveTo(pos: roundedValue)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


