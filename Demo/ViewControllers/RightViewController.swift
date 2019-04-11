//
//  RightViewController.swift
//  JSDrawer-Demo
//
//  Created by Max on 2019/4/11.
//  Copyright © 2019 Max. All rights reserved.
//

import UIKit

class RightViewController: UIViewController {

    // MARK:
    var dataSources: [String] = ["Present下一个界面", "Push下一个界面", "显示AlertView", "主动收起抽屉"]
    var actionDataSources: [Selector] = [#selector(presentNext), #selector(pushNext), #selector(presentAlertView), #selector(hideDrawer)]
    
    lazy var rightTableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0.0, y: 300.0, width: 0.75 * UIScreen.main.bounds.width, height: self.view.bounds.height - 300.0), style: .plain)
        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50.0
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "RightTableViewCell")
        return tableView
    }()
    
    var nextViewController: NextViewController = NextViewController()
    
    // MARK:
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.rightTableView)
    }
    
    // MARK:
    @objc func presentNext() {
        let navigationController = UINavigationController(rootViewController: self.nextViewController)
        self.js_presentViewController(navigationController, isDrawerHide: true)
    }
    
    @objc func pushNext() {
        self.js_pushViewController(self.nextViewController)
    }
    
    @objc func presentAlertView() {
        let alert = UIAlertController(title: "JSDrawer", message: "一个简便易用的侧滑抽屉框架。", preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "关闭", style: .default, handler: nil)
        alert.addAction(closeAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func hideDrawer() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension RightViewController: UITableViewDataSource {
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RightTableViewCell", for: indexPath) as UITableViewCell
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.text = self.dataSources[indexPath.row]
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
        cell.textLabel?.textColor = UIColor.white
        return cell
    }
}

extension RightViewController: UITableViewDelegate {
    
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
