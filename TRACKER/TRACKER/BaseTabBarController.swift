//
//  BaseTabBarController.swift
//  TRACKER
//
//  Created by saera on 2018. 8. 2..
//  Copyright © 2018년 OnlyNew. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let favoritesVC = ViewController()
        favoritesVC.title = "Favorites"
        favoritesVC.view.backgroundColor = UIColor.orange
        let downloadsVC = ViewController()
        downloadsVC.title = "Downloads"
        downloadsVC.view.backgroundColor = UIColor.blue
        let historyVC = ViewController()
        historyVC.title = "History"
        historyVC.view.backgroundColor = UIColor.cyan
        
        favoritesVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
        downloadsVC.tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 1)
        historyVC.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 2)
        
        let controllers = [favoritesVC, downloadsVC, historyVC]
        self.viewControllers = controllers
        
        //        t̶a̶b̶B̶a̶r̶C̶o̶n̶t̶r̶o̶l̶l̶e̶r̶.v̶i̶e̶w̶C̶o̶n̶t̶r̶o̶l̶l̶e̶r̶s̶ =̶ ̶c̶o̶n̶t̶r̶o̶l̶l̶e̶r̶s̶
        self.viewControllers = controllers.map { UINavigationController(rootViewController: $0)}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
