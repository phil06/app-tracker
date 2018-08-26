//
//  LoadViewController.swift
//  TRACKER
//
//  Created by saera on 2018. 8. 16..
//  Copyright © 2018년 OnlyNew. All rights reserved.
//

import UIKit

class LoadViewController: UIViewController {

    let tableView: UITableView = UITableView()
    var list: [String] = []
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        return refreshControl
    }()
    
    override func viewDidLoad() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.addSubview(self.refreshControl)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "fileCell")
        
        self.view.addSubview(self.tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive =  true
        
        tableView.tableFooterView = UIView(frame: .zero)
        
        loadData()
    }
 
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        loadData()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    private func loadData() {
        list = ONFileManager().readDirectoryNoneExtension()
    }
    
}

extension LoadViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "Delete") { (action, index) -> Void in
            ONFileManager().deleteFile(fileName: self.list[indexPath.row])
            self.list.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        deleteButton.backgroundColor = UIColor.red
        return [deleteButton]
    }
}

extension LoadViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard list.count > 0 else {
            return 1
        }

        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //MARK: designated initializer 를 사용하면 자동으로 reuseable cell을 가져오는건가...?
        let cell = FileListCell(style: UITableViewCellStyle.default, reuseIdentifier: "fileCell")
        
        cell.label.text = "파일이 없습니다"
        
        //아예 저장된게 없을때
        guard list.count > 0 else {
            return cell
        }
        
        

        let typeStr = UserDefaults.standard.value(forKey: list[indexPath.row]) as? String
        print("indexPath:\(indexPath.row), fileName:\(list[indexPath.row]), typeStr:\(typeStr)")
        // 악기를 알수없으면 편집화면도 열 수 없음
        guard typeStr != nil else {
            cell.label.text = "오류 파일"
            return cell
        }
        cell.type = InstrumentKind.init(rawValue: typeStr!)
        cell.icon.image = UIImage(named: cell.type.getIcon)
        cell.label.text = list[indexPath.row]
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tabListCell))
        cell.addGestureRecognizer(tap)
        
        return cell
    }
    
    @objc func tabListCell(sender: UITapGestureRecognizer) {
        let vc = CompositionViewController()
        if let cell = sender.view as? FileListCell {
            vc.instrumentType = cell.type
            vc.loadFile = cell.label.text
            self.present(vc, animated: true)
        }
    }
  
}

