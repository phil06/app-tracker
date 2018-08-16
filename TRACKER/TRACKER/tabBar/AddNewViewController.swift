//
//  MainViewController.swift
//  TRACKER
//
//  Created by saera on 2018. 8. 2..
//  Copyright © 2018년 OnlyNew. All rights reserved.
//

import UIKit

class AddNewViewController: UIViewController {
    
    let tableView: UITableView = UITableView()
    var selectedType: InstrumentKind!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.register(UITableViewCell.self,
                                  forCellReuseIdentifier: "instrumentCell")
        self.view.addSubview(self.tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive =  true
        
        tableView.tableFooterView = UIView(frame: .zero)
    }

}

extension AddNewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("선택된 행 : \(String(describing: InstrumentKind.init(code: indexPath.row)))")
        selectedType = InstrumentKind.init(code: indexPath.row)
    }
    
    //MARK: 버튼 이미지 변경할때 적용하기
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

extension AddNewViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return InstrumentKind.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //MARK: designated initializer 를 사용하면 자동으로 reuseable cell을 가져오는건가...?
        let cell = InstrumentCell(style: UITableViewCellStyle.default, reuseIdentifier: "instrumentCell")
        cell.button.addTarget(self, action: #selector(pressedBrowser(sender: )), for: .touchUpInside)
        
        
        
        return cell

    }
    
    @objc func pressedBrowser(sender: UIButton) {
        let vc = CompositionViewController()
        vc.instrumentType = selectedType
        self.present(vc, animated: true)
    }
    
    

}
