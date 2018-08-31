//
//  InstrumentCell.swift
//  TRACKER
//
//  Created by NHNEnt on 2018. 8. 6..
//  Copyright © 2018년 OnlyNew. All rights reserved.
//

import Foundation
import UIKit

class InstrumentCell: UITableViewCell {
    
    var button: UIButton!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 184, height: 90)
        button.setImage(UIImage(named: "icon_instrument_piano.png"), for: UIControlState.normal)
        contentView.addSubview(button)
        contentView.translatesAutoresizingMaskIntoConstraints = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
