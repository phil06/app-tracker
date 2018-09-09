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
    
    let ICON_INSTRUMENT_TYPE_WIDTH = 184
    let ICON_INSTRUMENT_TYPE_HEIGHT = 90

    var iconImage: UIImageView!
    var type: InstrumentKind!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.iconImage = UIImageView(frame: CGRect(x: 0, y: 0, width: ICON_INSTRUMENT_TYPE_WIDTH, height: ICON_INSTRUMENT_TYPE_HEIGHT))
        contentView.addSubview(self.iconImage)
        
        contentView.translatesAutoresizingMaskIntoConstraints = true
    }
    
    func setType(type: InstrumentKind) {
        self.type = type
        self.iconImage.image = UIImage(named: self.type.getMenuIcon)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
