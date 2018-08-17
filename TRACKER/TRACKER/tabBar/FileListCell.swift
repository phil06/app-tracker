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
        label.frame = CGRect.zero
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        
        icon = UIImageView()
        icon.frame = CGRect.zero
        icon.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(icon)
        
        contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        icon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        icon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 48).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        label.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 10).isActive = true
        label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        label.heightAnchor.constraint(equalTo: icon.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
