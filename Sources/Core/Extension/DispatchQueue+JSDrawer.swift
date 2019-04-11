//
//  DispatchQueue+JSDrawer.swift
//  JSDrawer
//
//  Created by Max on 2019/4/4.
//  Copyright © 2019 Max. All rights reserved.
//

import Foundation

extension DispatchQueue {
    
    // MARK:
    private static var onceTracker: [String] = [String]()
    
    // MARK:
    class func js_once(token: String, completionHandler: () -> ()) {
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        if self.onceTracker.contains(token) {
            return
        }
        self.onceTracker.append(token)
        completionHandler()
    }
}
