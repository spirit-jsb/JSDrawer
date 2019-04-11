//
//  JSDrawerMask.swift
//  JSDrawer
//
//  Created by Max on 2019/4/4.
//  Copyright © 2019 Max. All rights reserved.
//

import Foundation

class JSDrawerMask: UIView {
    
    // MARK:
    var toViewSubviews: [UIView] = [UIView]()
    
    private static var js_sharedInstance: JSDrawerMask? = nil
    
    private static var js_onceToken: String = UUID().uuidString
    
    // MARK:
    class func sharedInstance() -> JSDrawerMask? {
        DispatchQueue.js_once(token: self.js_onceToken, completionHandler: {
            self.js_sharedInstance = JSDrawerMask()
        })
        return self.js_sharedInstance
    }
    
    class func releaseInstance() {
        self.js_sharedInstance?.removeFromSuperview()
        self.js_onceToken = UUID().uuidString
        self.js_sharedInstance = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black
        self.alpha = 0.0
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(singleTapPressed(_:)))
        self.addGestureRecognizer(tapGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panHandle(_:)))
        self.addGestureRecognizer(panGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    // MARK:
    @objc private func singleTapPressed(_ tapGesture: UITapGestureRecognizer) {
        NotificationCenter.default.post(name: .singleTap, object: self)
    }
    
    @objc private func panHandle(_ panGesture: UIPanGestureRecognizer) {
        NotificationCenter.default.post(name: .pan, object: panGesture)
    }
}
