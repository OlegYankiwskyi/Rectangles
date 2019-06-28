//
//  AppConfig.swift
//  Rectangles
//
//  Created by OlegMac on 6/28/19.
//  Copyright © 2019 Oleg_Yankivskyi. All rights reserved.
//

import Foundation
import CoreGraphics

struct AppConfig {
    
    static let cornerTouchSize = CGSize(width: 60, height: 60)
    static let edgeTouchThickness: (vertical: CGFloat, horizontal: CGFloat) = (vertical: 60, horizontal: 60)
    static let minSize: CGFloat = 100
}
