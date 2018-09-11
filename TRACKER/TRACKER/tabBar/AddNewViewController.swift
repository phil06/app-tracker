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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "instrumentCell")
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

extension AddNewViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ALL_INSTRUMENT.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = InstrumentCell(style: UITableViewCellStyle.default, reuseIdentifier: "instrumentCell")
        cell.setType(type: ALL_INSTRUMENT[getInstrumentByIdx(idx: indexPath.row)]!)

        let tap = UITapGestureRecognizer(target: self, action: #selector(pressedBrowser))
        cell.addGestureRecognizer(tap)
        
        return cell
    }
    
    @objc func pressedBrowser(sender: UITapGestureRecognizer) {
        let vc = CompositionViewController()
       
        if let cell = sender.view as? InstrumentCell {
            vc.instrumentType = cell.type
            self.present(vc, animated: true)
        }
    }
    
    

}
