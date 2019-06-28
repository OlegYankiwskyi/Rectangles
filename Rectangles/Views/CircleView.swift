//
//  CircleView.swift
//  Rectangles
//
//  Created by OlegMac on 6/27/19.
//  Copyright © 2019 Oleg_Yankivskyi. All rights reserved.
//

import Foundation
import UIKit

class CircleView: UIView {
    
    init(position: CGPoint) {
        let circlePosition = CGPoint(x: position.x - AppConfig.circleSize/2, y: position.y - AppConfig.circleSize/2)
        let circleFrame = CGRect(origin: circlePosition, size: CGSize(width: AppConfig.circleSize, height: AppConfig.circleSize))
        super.init(frame: circleFrame)
        
        self.backgroundColor = .gray
        self.layer.cornerRadius = self.frame.size.width/2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
