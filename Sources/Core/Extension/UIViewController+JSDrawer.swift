//
//  UIViewController+JSDrawer.swift
//  JSDrawer
//
//  Created by Max on 2019/4/10.
//  Copyright © 2019 Max. All rights reserved.
//

import Foundation

private struct JSDrawerKeys {
    static var animator = "com.sibo.jian.JSDrawer.animator"
    static var direction = "com.sibo.jian.JSDrawer.direction"
}

public extension UIViewController {
    
    // MARK:
    func js_showDrawer(_ viewController: UIViewController, animationType: AnimationType, config: JSDrawerConfig? = nil) {
        var animator = objc_getAssociatedObject(self, &JSDrawerKeys.animator) as? JSDrawerAnimator
        
        var config = config
        
        if config == nil {
            config = JSDrawerConfig()
        }
        
        let hideInteraction = JSDrawerInteractionTransition(transitionType: .hide)
        hideInteraction.config = config
        hideInteraction.weakViewController = viewController
        hideInteraction.transitionDirection = config!.direction
        
        if animator == nil {
            animator = JSDrawerAnimator(config: config, hideInteraction: hideInteraction)
            animator?.animationType = animationType
            objc_setAssociatedObject(viewController, &JSDrawerKeys.animator, animator, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        viewController.transitioningDelegate = animator
        
        objc_setAssociatedObject(viewController, &JSDrawerKeys.direction, config!.direction.rawValue, .OBJC_ASSOCIATION_ASSIGN)
 
        self.present(viewController, animated: true, completion: nil)
    }

    func js_pushViewController(_ viewController: UIViewController, hideAnimateDuration: TimeInterval = 0.0) {
        guard let animator = self.transitioningDelegate as? JSDrawerAnimator else {
            return
        }
        
        guard let animatorConfig = animator.config else {
            return
        }
        
        animatorConfig.hideAnimateDuration = hideAnimateDuration > 0.0 ? hideAnimateDuration : animatorConfig.hideAnimateDuration
        
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        
        var navigationController: UINavigationController?
        var transitionType: CATransitionType = .push
        
        if rootViewController?.isKind(of: UITabBarController.self) ?? false {
            let tabBarController = rootViewController as! UITabBarController
            let selectedIndex = tabBarController.selectedIndex
            navigationController = tabBarController.children[selectedIndex] as? UINavigationController
        }
        else if rootViewController?.isKind(of: UINavigationController.self) ?? false {
            if animator.animationType == .default {
                transitionType = .fade
            }
            navigationController = rootViewController as? UINavigationController
        }
        
        guard let direction = objc_getAssociatedObject(self, &JSDrawerKeys.direction) as? Int else {
            return
        }
        
        let transitionSubtype: CATransitionSubtype = direction == TransitionDirection.left.rawValue ? .fromLeft : .fromRight
        
        let transition = CATransition()
        transition.duration = 0.2
        transition.timingFunction = CAMediaTimingFunction(name: .easeOut)
        transition.type = transitionType
        transition.subtype = transitionSubtype
        
        navigationController?.view.layer.add(transition, forKey: nil)
        
        self.dismiss(animated: true, completion: nil)
        
        navigationController?.pushViewController(viewController, animated: false)
    }
    
    func js_presentViewController(_ viewController: UIViewController, isDrawerHide: Bool = false) {
        let keyWindow = UIApplication.shared.keyWindow
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        
        viewController.view.frame = CGRect(x: 0.0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        viewController.view.tag = TAG
        
        keyWindow?.addSubview(viewController.view)
        
        UIView.animate(withDuration: 0.25, animations: {
            viewController.view.frame = CGRect(x: 0.0, y: 0.0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        }, completion: { (_) in
            rootViewController?.addChild(viewController)
            if isDrawerHide {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    func js_dismissViewController() {
        if self.view.tag != TAG && self.parent?.view.tag != TAG {
            return
        }
        
        var weakSelf: UIViewController? = self
        if self.parent?.view.tag == TAG {
            weakSelf = self.parent
        }
        weakSelf?.edgesForExtendedLayout = []
        
        UIView.animate(withDuration: 0.25, animations: {
            weakSelf?.view.frame = CGRect(x: 0.0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        }, completion: { (_) in
            weakSelf?.view.removeFromSuperview()
            weakSelf?.removeFromParent()
        })
    }
}
