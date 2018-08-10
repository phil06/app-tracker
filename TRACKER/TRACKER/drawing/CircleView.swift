//
//  CircleView.swift
//  TRACKER
//
//  Created by NHNEnt on 2018. 8. 7..
//  Copyright © 2018년 OnlyNew. All rights reserved.
//

import UIKit

class CircleView: UIView {
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .gray
        print("그리드 뷰가 되어야 할 아이")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .gray
        print("그리드 뷰가 되어양 할 아이인데, 사이즈 지정함")
        
        self.isUserInteractionEnabled = true
  
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



