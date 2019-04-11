//
//  FirstViewController.swift
//  JSDrawer-Demo
//
//  Created by Max on 2019/4/10.
//  Copyright © 2019 Max. All rights reserved.
//

import UIKit
import JSDrawer

class FirstViewController: UIViewController {

    // MARK:
    var dataSources: [String] = ["仿QQ左侧划出", "仿QQ右侧划出", "缩小从左侧划出", "缩小从右侧划出", "遮盖在上面从左侧划出", "遮盖在上面从右侧划出"]
    var actionDataSources: [Selector] = [#selector(showLeftDrawerDefaultAnimation), #selector(showRightDrawerDefaultAnimation), #selector(showLeftDrawerScaleAnimation), #selector(showRightDrawerScaleAnimation), #selector(showLeftDrawerMaskAnimation), #selector(showRightDrawerMaskAnimation)]
    
    var leftViewController: LeftViewController = LeftViewController()
    var rightViewController: RightViewController = RightViewController()
    
    lazy var firstTableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50.0
        tableView.separatorStyle = .singleLine
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "FirstTableViewCell")
        return tableView
    }()
        
    // MARK:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.firstTableView)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "左侧", style: .plain, target: self, action: #selector(showLeftDrawerDefaultAnimation))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "右侧", style: .plain, target: self, action: #selector(showRightDrawerScaleAnimation))
    }
    
    // MARK:
    @objc func showLeftDrawerDefaultAnimation() {
        self.js_showDrawer(self.leftViewController, animationType: .default, config: nil)
    }
    
    @objc func showRightDrawerDefaultAnimation() {
        let config = JSDrawerConfig()
        config.direction = .right
        config.finishPercent = 0.2
        config.showAnimateDuration = 0.2
        config.hideAnimateDuration = 0.2
        config.maskAlpha = 0.1
        self.js_showDrawer(self.leftViewController, animationType: .default, config: config)
    }
    
    @objc func showLeftDrawerScaleAnimation() {
        let config = JSDrawerConfig()
        config.distance = 0.0
        config.scaleY = 0.8
        config.backgroundImage = UIImage(named: "background")
        self.js_showDrawer(self.rightViewController, animationType: .default, config: config)
    }
    
    @objc func showRightDrawerScaleAnimation() {
        let config = JSDrawerConfig()
        config.direction = .right
        config.finishPercent = 0.1
        config.showAnimateDuration = 1.0
        config.backgroundImage = UIImage(named: "background")
        config.scaleY = 0.8
        self.js_showDrawer(self.rightViewController, animationType: .default, config: config)
    }
    
    @objc func showLeftDrawerMaskAnimation() {
        self.js_showDrawer(self.leftViewController, animationType: .mask, config: nil)
    }
    
    @objc func showRightDrawerMaskAnimation() {
        let config = JSDrawerConfig()
        config.direction = .right
        config.showAnimateDuration = 1.0
        self.js_showDrawer(self.leftViewController, animationType: .mask, config: config)
    }
}

extension FirstViewController: UITableViewDataSource {
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FirstTableViewCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = self.dataSources[indexPath.row]
        return cell
    }
}

extension FirstViewController: UITableViewDelegate {
    
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
