//
//  JSDrawerConfig.swift
//  JSDrawer
//
//  Created by Max on 2019/4/4.
//  Copyright © 2019 Max. All rights reserved.
//

import Foundation

public class JSDrawerConfig {
    
    // MARK:
    public var distance: CGFloat {
        set {
            self.distance_ = newValue
        }
        get {
            return self.distance_ <= 0.0 ? SCREEN_WIDTH * 0.75 : self.distance_
        }
    }
    
    public var finishPercent: CGFloat {
        set {
            self.finishPercent_ = newValue
        }
        get {
            return self.finishPercent_ <= 0.0 ? 0.4 : self.finishPercent_
        }
    }
    
    public var showAnimateDuration: TimeInterval {
        set {
            self.showAnimateDuration_ = newValue
        }
        get {
            return self.showAnimateDuration_ <= 0.0 ? 0.25 : self.showAnimateDuration_
        }
    }
    
    public var hideAnimateDuration: TimeInterval {
        set {
            self.hideAnimateDuration_ = newValue
        }
        get {
            return self.hideAnimateDuration_ <= 0.0 ? 0.25 : self.hideAnimateDuration_
        }
    }
    
    public var maskAlpha: CGFloat {
        set {
            self.maskAlpha_ = newValue
        }
        get {
            return self.maskAlpha_ <= 0.0 ? 0.4 : self.maskAlpha_
        }
    }
    
    public var scaleY: CGFloat {
        set {
            self.scaleY_ = newValue
        }
        get {
            return self.scaleY_ <= 0.0 ? 1.0 : self.scaleY_
        }
    }
    
    public var direction: TransitionDirection
    
    public var backgroundImage: UIImage?
    
    private var distance_: CGFloat
    private var finishPercent_: CGFloat
    private var showAnimateDuration_: TimeInterval
    private var hideAnimateDuration_: TimeInterval
    private var maskAlpha_: CGFloat
    private var scaleY_: CGFloat
    
    // MARK:
    public init() {
        self.distance_ = SCREEN_WIDTH * 0.75
        self.finishPercent_ = 0.4
        self.showAnimateDuration_ = 0.25
        self.hideAnimateDuration_ = 0.25
        self.maskAlpha_ = 0.4
        self.scaleY_ = 1.0
        self.direction = .left
        self.backgroundImage = nil
    }
    
    public init(distance: CGFloat, maskAlpha: CGFloat, scaleY: CGFloat, direction: TransitionDirection, backgroundImage: UIImage?) {
        self.distance_ = distance
        self.finishPercent_ = 0.4
        self.showAnimateDuration_ = 0.25
        self.hideAnimateDuration_ = 0.25
        self.maskAlpha_ = maskAlpha
        self.scaleY_ = scaleY
        self.direction = direction
        self.backgroundImage = backgroundImage
    }
}
