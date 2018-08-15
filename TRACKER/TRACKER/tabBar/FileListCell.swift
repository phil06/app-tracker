//
//  FileListCell.swift
//  TRACKER
//
//  Created by saera on 2018. 8. 16..
//  Copyright © 2018년 OnlyNew. All rights reserved.
//

import UIKit

//MARK: 화면 리펙토링 하기
class FileListCell: UITableViewCell {
    
    var label: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 300, height: 70)
        label.text = "파일명"
        label.isUserInteractionEnabled = true
        contentView.addSubview(label)
        
        contentView.translatesAutoresizingMaskIntoConstraints = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
