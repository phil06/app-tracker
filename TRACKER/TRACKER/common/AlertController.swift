//
//  AlertController.swift
//  TRACKER
//
//  Created by NHNEnt on 2018. 8. 9..
//  Copyright © 2018년 OnlyNew. All rights reserved.
//

import UIKit

class AlertController {

    func showMessageWithYesFunction(byYes: @escaping () -> Void, pTitle: String, pMessage: String) -> UIAlertController {
        
        let alert = UIAlertController(title: pTitle, message: pMessage, preferredStyle: .alert)

        let okBtn = UIAlertAction(title: "예", style: .default, handler: { (_) in
            byYes()
        })
        let cancelBtn = UIAlertAction(title: "아니오", style: .cancel)
        
        alert.addAction(okBtn)
        alert.addAction(cancelBtn)
        
        return alert
    }
    
    func showMessageWithInput(by: @escaping (_ fileName: String) -> Void, pTitle: String, pMessage: String, placeHolder: String) -> UIAlertController {
        let alert = UIAlertController(title: pTitle, message: pMessage, preferredStyle: .alert)

        let okBtn = UIAlertAction(title: "저장", style: .default, handler: { (_) in
            if let tf = alert.textFields?[0] {
                print("파일명은 > \(tf.text!)")
                by(tf.text!)
            }
        })
        let cancelBtn = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addTextField(configurationHandler: { (tf) in
            tf.text = placeHolder
        })
        alert.addAction(okBtn)
        alert.addAction(cancelBtn)
        
        return alert
    }
    
    func showMessage(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default)
        alert.addAction(ok)
        return alert
    }

}
