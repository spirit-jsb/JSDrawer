//
//  SecondViewController.swift
//  JSDrawer-Demo
//
//  Created by Max on 2019/4/10.
//  Copyright © 2019 Max. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    // MARK:
    var dataSources: [String] = ["仿QQ左侧划出", "仿QQ右侧划出", "缩小从左侧划出", "缩小从右侧划出", "遮盖在上面从左侧划出", "遮盖在上面从右侧划出"]
    
    lazy var secondTableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50.0
        tableView.separatorStyle = .singleLine
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SecondTableViewCell")
        return tableView
    }()
    
    // MARK:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.secondTableView)
    }
}

extension SecondViewController: UITableViewDataSource {
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SecondTableViewCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = self.dataSources[indexPath.row]
        return cell
    }
}

extension SecondViewController: UITableViewDelegate {
    
    // MARK: UITableViewDelegate
}
