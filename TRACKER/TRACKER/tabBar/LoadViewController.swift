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
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        loadData()
        self.tableView.addSubview(self.refreshControl)
        
        self.tableView.register(UITableViewCell.self,
                                forCellReuseIdentifier: "fileCell")
        self.view.addSubview(self.tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive =  true
        
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    private func loadData() {
        list = ONFileManager().readDirectory()
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        loadData()
        
        list.insert("테스트용 추가", at: list.count)
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
}

extension LoadViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("선택된 행 : \(String(describing: InstrumentKind.init(rawValue: indexPath.row)))")
//        selectedType = InstrumentKind.init(rawValue: indexPath.row)
    }
    
    //MARK: 버튼 이미지 변경할때 적용하기
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension LoadViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return InstrumentKind.count
        if list.count == 0 {
            return 1
        } else {
            return list.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //MARK: designated initializer 를 사용하면 자동으로 reuseable cell을 가져오는건가...?
        let cell = FileListCell(style: UITableViewCellStyle.default, reuseIdentifier: "fileCell")
        if list.count == 0 {
            cell.label.text = "파일이 없습니다"
            return cell
        }
        
        cell.label.text = list[indexPath.row]
        let tap = UITapGestureRecognizer(target: self, action: #selector(pressedBrowser))
        cell.label.addGestureRecognizer(tap)
        
        return cell
        
    }
    
    @objc func pressedBrowser(sender: UITapGestureRecognizer) {
        let vc = CompositionViewController()
        //MARK: 일단 하드코딩
       vc.instrumentType = InstrumentKind.PIANO
        self.present(vc, animated: true)
    }
  
}

