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
    var type: InstrumentKind!
    var icon: UIImageView!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        //MARK: 오토레이아웃 적용하기
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        label = UILabel()
        label.frame = CGRect(x: 10, y: 10, width: 300, height: 30)
        label.isUserInteractionEnabled = true
        contentView.addSubview(label)
        
        icon = UIImageView()
        icon.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        contentView.addSubview(icon)
        
        contentView.translatesAutoresizingMaskIntoConstraints = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
