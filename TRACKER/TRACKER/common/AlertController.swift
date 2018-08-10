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
}
