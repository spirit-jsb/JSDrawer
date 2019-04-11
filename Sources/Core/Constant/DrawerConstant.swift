//
//  DrawerConstant.swift
//  JSDrawer
//
//  Created by Max on 2019/4/4.
//  Copyright © 2019 Max. All rights reserved.
//

import Foundation

let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height
let TAG = 588566

public typealias TransitionDirectionHandler = (TransitionDirection) -> (Void)

public enum TransitionDirection: Int {
    case left
    case right
}

public enum AnimationType {
    case `default`
    case mask
}

enum TransitionType {
    case show
    case hide
}
