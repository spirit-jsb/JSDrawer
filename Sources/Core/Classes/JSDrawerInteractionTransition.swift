//
//  JSDrawerInteractionTransition.swift
//  JSDrawer
//
//  Created by Max on 2019/4/4.
//  Copyright © 2019 Max. All rights reserved.
//

import Foundation

class JSDrawerInteractionTransition: UIPercentDrivenInteractiveTransition {
    
    // MARK:
    weak var config: JSDrawerConfig?
    
    weak var weakViewController: UIViewController?
    
    var interacting: Bool = false
    
    var transitionDirection: TransitionDirection = .left
    
    private var transitionType: TransitionType
    
    private var displayLink: CADisplayLink?
    
    private var percent: CGFloat = 0.0
    
    private var tempPrecent: CGFloat = 0.0
    
    private var remainCount: CGFloat = 0.0
    
    private var isFinish: Bool = false
    
    // MARK:
    init(transitionType: TransitionType) {
        self.transitionType = transitionType
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(js_singleTapPressed(_:)), name: .singleTap, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(js_panHideHandle(_:)), name: .pan, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .singleTap, object: nil)
        NotificationCenter.default.removeObserver(self, name: .pan, object: nil)
    }
    
    // MARK:

    // MAKR:
    private func link() -> CADisplayLink? {
        guard let link = self.displayLink else {
            self.displayLink = CADisplayLink(target: self, selector: #selector(js_update))
            self.displayLink?.add(to: .current, forMode: .common)
            return self.displayLink
        }
        return link
    }
    
    private func startDisplayLink() {
        self.link()
    }
    
    private func stopDisplayLink() {
        self.displayLink?.invalidate()
        self.displayLink = nil
    }
    
    private func beganShow(_ translationX: CGFloat, panGesture: UIPanGestureRecognizer) {
        self.transitionDirection = translationX >= 0.0 ? .left : .right
        
        if (translationX < 0.0 && self.transitionDirection == .left) ||
            (translationX > 0.0 && self.transitionDirection == .right) {
            return
        }
        
        self.interacting = true
    }
    
    private func beganHide(_ translationX: CGFloat) {
        if (translationX > 0.0 && self.transitionDirection == .left) ||
            (translationX < 0.0 && self.transitionDirection == .right) {
            return
        }
        
        self.interacting = true
        
        self.weakViewController?.dismiss(animated: true, completion: nil)
    }
    
    private func js_updatePercentComplete() {
        self.percent = fmin(fmax(self.percent, 0.003), 0.97)
        self.update(self.percent)
    }
    
    private func js_endPercentComplete() {
        self.interacting = false
        self.startTimerAnimationWithFinishTransition(self.percent > self.config?.finishPercent ?? 0.0)
    }
    
    private func startTimerAnimationWithFinishTransition(_ isFinish: Bool) {
        if isFinish && self.percent >= 1.0 {
            self.finish()
            return
        }
        else if !isFinish && self.percent <= 0.0 {
            self.cancel()
            return
        }
        self.isFinish = isFinish
        let remainDuration = isFinish ? self.duration * (1.0 - self.percent) : self.duration * self.percent
        self.remainCount = 60.0 * remainDuration
        self.tempPrecent = isFinish ? (1.0 - self.percent) / self.remainCount : self.percent / self.remainCount
        self.startDisplayLink()
    }
    
    private func handlePanGesture(_ panGesture: UIPanGestureRecognizer) {
        guard let panGestureView = panGesture.view else {
            return
        }
        
        let translationX = panGesture.translation(in: panGestureView).x
        
        self.percent = 0.0
        self.percent = translationX / panGestureView.frame.size.width
        
        if (self.transitionDirection == .right && self.transitionType == .show) ||
            (self.transitionDirection == .left && self.transitionType == .hide) {
            self.percent = -(self.percent)
        }
        
        switch panGesture.state {
        case .began:
            break
        case .changed:
            if !self.interacting {
                if self.transitionType == .show {
                    if abs(translationX) > 20.0 {
                        self.beganShow(translationX, panGesture: panGesture)
                    }
                }
                else {
                    self.beganHide(translationX)
                }
            }
            else {
                self.js_updatePercentComplete()
            }
        case .cancelled, .ended:
            self.js_endPercentComplete()
        default:
            break
        }
    }
    
    // MARK:
    @objc private func js_update() {
        if self.percent >= 0.97 && self.isFinish {
            self.stopDisplayLink()
            self.finish()
        }
        else if self.percent <= 0.03 && !self.isFinish {
            self.stopDisplayLink()
            self.cancel()
        }
        else {
            if self.isFinish {
                self.percent += self.tempPrecent
            }
            else {
                self.percent -= self.tempPrecent
            }
            let percent = fmin(fmax(self.percent, 0.03), 0.97)
            self.update(percent)
        }
    }
    
    @objc private func js_singleTapPressed(_ notification: Notification) {
        if self.transitionType == .show {
            return
        }
        self.weakViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func js_panShowHandle(_ panGesture: UIPanGestureRecognizer) {
        if self.transitionType == .hide {
            return
        }
        self.handlePanGesture(panGesture)
    }
    
    @objc private func js_panHideHandle(_ notification: Notification) {
        if self.transitionType == .show {
            return
        }
        let panGesture = notification.object as! UIPanGestureRecognizer
        self.handlePanGesture(panGesture)
    }
    
    @objc private func js_edgePanHandle(_ edgePanGesture: UIScreenEdgePanGestureRecognizer) {
        guard let edgePanGestureView = edgePanGesture.view else {
            return
        }
        
        if self.transitionType == .hide {
            return
        }
        
        let translationX = edgePanGesture.translation(in: edgePanGestureView).x
        
        self.percent = 0.0
        self.percent = translationX / edgePanGestureView.frame.size.width
        
        self.transitionDirection = edgePanGesture.edges == .right ? .right : .left
        
        if self.transitionDirection == .right {
            self.percent = -(self.percent)
        }
        
        switch edgePanGesture.state {
        case .began:
            self.interacting = true
        case .changed:
            self.js_updatePercentComplete()
        case .cancelled, .ended:
            self.js_endPercentComplete()
        default:
            break
        }
    }
}

extension JSDrawerInteractionTransition: UIGestureRecognizerDelegate {
    
    // MARK: UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if (otherGestureRecognizer.view?.js_viewController)?.isKind(of: UITableViewController.self) ?? false {
            return true
        }
        return false
    }
}
