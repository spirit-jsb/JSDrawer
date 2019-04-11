//
//  JSDrawerTransition.swift
//  JSDrawer
//
//  Created by Max on 2019/4/4.
//  Copyright © 2019 Max. All rights reserved.
//

import Foundation

class JSDrawerTransition: NSObject {
    
    // MARK:
    private var transitionType: TransitionType
    
    private var animationType: AnimationType
    
    private var config: JSDrawerConfig
    
    private var hideDelayTime: TimeInterval = 0.0
    
    // MARK:
    init(transitionType: TransitionType, animationType: AnimationType, config: JSDrawerConfig) {
        self.transitionType = transitionType
        self.animationType = animationType
        self.config = config
        super.init()
        if self.transitionType == .hide {
            self.resetHideDelayTime()
        }
    }

    // MARK:
    private func resetHideDelayTime() {
        self.hideDelayTime = 0.0
        if #available(iOS 11.0, *) {
            self.hideDelayTime = 0.03
        }
    }
    
    private func showAnimateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch self.animationType {
        case .default:
            self.defaultAnimateTransition(using: transitionContext)
        case .mask:
            self.maskAnimateTransition(using: transitionContext)
        }
    }
    
    private func hideAnimateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let mask = JSDrawerMask.sharedInstance(), let from = transitionContext.viewController(forKey: .from), let to = transitionContext.viewController(forKey: .to) else {
            return
        }
        
        if !to.isKind(of: UINavigationController.self) {
            for subview in to.view.subviews {
                if !mask.toViewSubviews.contains(subview) {
                    subview.removeFromSuperview()
                }
            }
        }
        
        let containerView = transitionContext.containerView
        
        let backgrountImageView: UIImageView? = containerView.subviews.first as? UIImageView
        
        UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext), delay: self.hideDelayTime, options: .calculationModeLinear, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0, animations: {
                to.view.transform = CGAffineTransform.identity
                from.view.transform = CGAffineTransform.identity
                mask.alpha = 0.0
                backgrountImageView?.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
            })
        }, completion: { (_) in
            if !transitionContext.transitionWasCancelled {
                mask.toViewSubviews.removeAll()
                JSDrawerMask.releaseInstance()
                backgrountImageView?.removeFromSuperview()
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    private func defaultAnimateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let mask = JSDrawerMask.sharedInstance(), let from = transitionContext.viewController(forKey: .from), let to = transitionContext.viewController(forKey: .to) else {
            return
        }
        
        mask.frame = from.view.bounds
        from.view.addSubview(mask)
        
        let containerView = transitionContext.containerView
        
        var backgroundImageView: UIImageView?
        if let backgroundImage = self.config.backgroundImage {
            backgroundImageView = UIImageView(frame: containerView.bounds)
            backgroundImageView?.image = backgroundImage
            backgroundImageView?.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
            backgroundImageView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            containerView.addSubview(backgroundImageView!)
        }
        
        let distanceWidth = self.config.distance
        var distanceX = -(distanceWidth / 2.0)
        var vector: CGFloat = 1.0
        if self.config.direction == .right {
            distanceX = SCREEN_WIDTH - (distanceWidth / 2.0)
            vector = -1.0
        }
        
        to.view.frame = CGRect(x: distanceX, y: 0.0, width: containerView.frame.width, height: containerView.frame.height)
        
        containerView.addSubview(to.view)
        containerView.addSubview(from.view)
        
        // 计算缩放后平移的距离
        let translationX = distanceWidth - (SCREEN_WIDTH * (1.0 - self.config.scaleY) / 2.0)
        
        let transform1 = CGAffineTransform(scaleX: self.config.scaleY, y: self.config.scaleY)
        let transform2 = CGAffineTransform(translationX: vector * translationX, y: 0.0)
        
        let fromTransform = transform1.concatenating(transform2)
        var toTransform: CGAffineTransform
        if self.config.direction == .right {
            toTransform = CGAffineTransform(translationX: vector * (distanceX - containerView.frame.width + distanceWidth), y: 0.0)
        }
        else {
            toTransform = CGAffineTransform(translationX: vector * distanceWidth / 2.0, y: 0.0)
        }

        UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext), delay: 0.0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0, animations: {
                from.view.transform = fromTransform
                to.view.transform = toTransform
                backgroundImageView?.transform = CGAffineTransform.identity
                mask.alpha = self.config.maskAlpha
            })
        }, completion: { (_) in
            if !transitionContext.transitionWasCancelled {
                mask.isUserInteractionEnabled = true
                if !to.isKind(of: UINavigationController.self) {
                    mask.toViewSubviews = from.view.subviews
                }
                transitionContext.completeTransition(true)
                containerView.addSubview(from.view)
            }
            else {
                backgroundImageView?.removeFromSuperview()
                JSDrawerMask.releaseInstance()
                transitionContext.completeTransition(false)
            }
        })
    }
    
    private func maskAnimateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let mask = JSDrawerMask.sharedInstance(), let from = transitionContext.viewController(forKey: .from), let to = transitionContext.viewController(forKey: .to) else {
            return
        }
        
        mask.frame = from.view.bounds
        from.view.addSubview(mask)
        
        let containerView = transitionContext.containerView
        
        let distanceWidth = self.config.distance
        var distanceX = -(distanceWidth)
        var vector: CGFloat = 1.0
        if self.config.direction == .right {
            distanceX = SCREEN_WIDTH
            vector = -1.0
        }
        
        to.view.frame = CGRect(x: distanceX, y: 0.0, width: distanceWidth, height: containerView.frame.height)
        
        containerView.addSubview(from.view)
        containerView.addSubview(to.view)
        
        let toTransform = CGAffineTransform(translationX: vector * distanceWidth, y: 0.0)

        UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext), delay: 0.0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0, animations: {
                to.view.transform = toTransform
                mask.alpha = self.config.maskAlpha
            })
        }, completion: { (_) in
            if !transitionContext.transitionWasCancelled {
                transitionContext.completeTransition(true)
                mask.toViewSubviews = from.view.subviews
                containerView.addSubview(from.view)
                containerView.bringSubviewToFront(to.view)
                mask.isUserInteractionEnabled = true
            }
            else {
                JSDrawerMask.releaseInstance()
                transitionContext.completeTransition(false)
            }
        })
    }
}

extension JSDrawerTransition: UIViewControllerAnimatedTransitioning {
    
    // MARK: UIViewControllerAnimatedTransitioning
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.transitionType == .show ? self.config.showAnimateDuration : self.config.hideAnimateDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch self.transitionType {
        case .show:
            self.showAnimateTransition(using: transitionContext)
        case .hide:
            self.hideAnimateTransition(using: transitionContext)
        }
    }
}
