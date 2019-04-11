//
//  NextViewController.swift
//  JSDrawer-Demo
//
//  Created by Max on 2019/4/11.
//  Copyright © 2019 Max. All rights reserved.
//

import UIKit

class NextViewController: UIViewController {

    // MARK:
    var dataSources: [String] = ["Dismiss", "Pop"]
    var actionDataSources: [Selector] = [#selector(dismissNext), #selector(popNext)]
    
    lazy var nextTableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50.0
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NextTableViewCell")
        return tableView
    }()
    
    // MARK:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hidesBottomBarWhenPushed = true
        
        self.view.addSubview(self.nextTableView)
    }
    
    // MARK:
    @objc func dismissNext() {
        self.js_dismissViewController()
    }
    
    @objc func popNext() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension NextViewController: UITableViewDataSource {
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NextTableViewCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = self.dataSources[indexPath.row]
        return cell
    }
}

extension NextViewController: UITableViewDelegate {
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selector = self.actionDataSources[indexPath.row]
        typealias functionHandler = @convention(c)(AnyObject, Selector) -> Void
        if self.responds(to: selector) {
            let imp = self.method(for: selector)
            let function = unsafeBitCast(imp, to: functionHandler.self)
            function(self, selector)
        }
    }
}
