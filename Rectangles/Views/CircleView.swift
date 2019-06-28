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
    
    private let radius: CGFloat = 10
    
    init(position: CGPoint) {
        let circlePosition = CGPoint(x: position.x - self.radius, y: position.y - self.radius)
        let circleFrame = CGRect(origin: circlePosition, size: CGSize(width: self.radius*2, height: self.radius*2))
        super.init(frame: circleFrame)
        
        self.backgroundColor = .gray
        self.layer.cornerRadius = self.frame.size.width/2
//        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
