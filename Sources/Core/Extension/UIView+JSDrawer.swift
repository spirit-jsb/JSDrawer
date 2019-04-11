//
//  UIView+JSDrawer.swift
//  JSDrawer
//
//  Created by Max on 2019/4/4.
//  Copyright © 2019 Max. All rights reserved.
//

import Foundation

extension UIView {
    
    // MARK:
    var js_viewController: UIViewController? {
        for nextView in sequence(first: self, next: { $0?.superview }) {
            if let nextResponder = nextView?.next {
                if nextResponder.isKind(of: UIViewController.self) {
                    return nextResponder as? UIViewController
                }
            }
        }
        return nil
    }
}
