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

        let addNewVC = AddNewViewController()
        let guideVC = GuideViewController()
        guideVC.title = "홈"
        guideVC.view.backgroundColor = UIColor.blue
        let listVC = LoadViewController()

        guideVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: TabBarImage.TAB_BAR_ITEM_HOME_IMG.rawValue), tag: 0)
        addNewVC.tabBarItem = UITabBarItem(title: "새로 만들기", image: UIImage(named: TabBarImage.TAB_BAR_ITEM_NEW_IMG.rawValue), tag: 1)
        listVC.tabBarItem = UITabBarItem(title: "리스트 보기", image: UIImage(named: TabBarImage.TAB_BAR_ITEM_LIST_IMG.rawValue), tag: 2)
        
        let controllers = [guideVC, addNewVC, listVC]
        
        //탭바에 뷰 컨트롤러 넣음
        self.viewControllers = controllers

    }

}
