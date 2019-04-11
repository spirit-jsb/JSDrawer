//
//  JSDrawerAnimator.swift
//  JSDrawer
//
//  Created by Max on 2019/4/4.
//  Copyright © 2019 Max. All rights reserved.
//

import Foundation

class JSDrawerAnimator: NSObject {
    
    // MAKR:
    var config: JSDrawerConfig?
    
    var showInteraction: JSDrawerInteractionTransition?
    
    var hideInteraction: JSDrawerInteractionTransition?
    
    var animationType: AnimationType = .default
    
    // MARK:
    init(config: JSDrawerConfig?, showInteraction: JSDrawerInteractionTransition? = nil, hideInteraction: JSDrawerInteractionTransition? = nil) {
        self.config = config
        self.showInteraction = showInteraction
        self.hideInteraction = hideInteraction
        super.init()
    }
}

extension JSDrawerAnimator: UIViewControllerTransitioningDelegate {
    
    // MARK: UIViewControllerTransitioningDelegate
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let config = self.config else {
            return nil
        }
        return JSDrawerTransition(transitionType: .show, animationType: self.animationType, config: config)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let config = self.config else {
            return nil
        }
        return JSDrawerTransition(transitionType: .hide, animationType: self.animationType, config: config)
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let showInteraction = self.showInteraction else {
            return nil
        }
        return showInteraction.interacting ? showInteraction : nil
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let hideInteraction = self.hideInteraction else {
            return nil
        }
        return hideInteraction.interacting ? hideInteraction : nil
    }
}
