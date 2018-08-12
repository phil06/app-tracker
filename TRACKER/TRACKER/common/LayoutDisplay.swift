//
//  LayoutDisplay.swift
//  TRACKER
//
//  Created by NHNEnt on 2018. 8. 8..
//  Copyright © 2018년 OnlyNew. All rights reserved.
//

import UIKit

class LayoutDisplay {
    
    func getSafeAreaInset() -> UIEdgeInsets {
        let window = UIApplication.shared.keyWindow
        let top = window?.safeAreaInsets.top
        let bottom = window?.safeAreaInsets.bottom
        let left = window?.safeAreaInsets.left
        let right = window?.safeAreaInsets.right
        
        print("safeAreaInset top:\(String(describing: top)), left:\(String(describing: left)), bottom:\(String(describing: bottom)), right:\(String(describing: right))")
        return UIEdgeInsetsMake(top!, left!, bottom!, right!)
    }
    
    //gap 에 대한건 아직 구현을 안했음.....;;
    func horizontalArrange(objects: [UIView], autoLast: Bool, gap: CGFloat, container: UIView) -> UIView {

        let baseView = UIView()
        baseView.translatesAutoresizingMaskIntoConstraints = false
        
        var leadingPos: CGFloat = 0
        let containerWidth: CGFloat = container.frame.width

        objects.forEach { (view) in
            
            let viewWidth = view.frame.width
            
            baseView.addSubview(view)
            view.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
            view.heightAnchor.constraint(equalTo: container.heightAnchor).isActive = true
            view.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: leadingPos)
            if view == objects.last && autoLast {
                //width resizing
                view.widthAnchor.constraint(equalToConstant: containerWidth - leadingPos).isActive = true
            } else {
                view.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
            }
            
            leadingPos += viewWidth
            
        }
        
        return baseView
    }
    
    func horizontalAlign(view: UIView) {
        
        var leadingPos: CGFloat = 0
        //landscape 일때 width가 아닌 height을 바라봄
        let containerWidth: CGFloat = view.frame.height
        
        view.subviews.forEach { (subView) in

            let viewWidth = subView.frame.width
            
//            if view == view.subviews.last {
//                //width resizing
//                view.frame = CGRect(x: 0, y: 0, width: containerWidth - leadingPos, height: subView.frame.height)
//            }
            subView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//            subView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
            subView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingPos).isActive = true

//            else {
//                view.widthAnchor.constraint(equalToConstant: viewWidth).isActive = true
//            }
            
            leadingPos += viewWidth
        }
    }
}
