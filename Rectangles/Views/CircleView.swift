//
//  CircleView.swift
//  Rectangles
//
//  Created by OlegMac on 6/27/19.
//  Copyright © 2019 Oleg_Yankivskyi. All rights reserved.
//

import Foundation
import UIKit

enum CircleSize {
    case middle
    case small
    
    var size: CGFloat {
        switch self {
        case .middle:
            return 20
        case .small:
            return 10
        }
    }
}

class CircleView: UIView {
    
    init(position: CGPoint, size circleSize: CircleSize = .middle) {
        let circlePosition = CGPoint(x: position.x - circleSize.size/2, y: position.y - circleSize.size/2)
        let circleFrame = CGRect(origin: circlePosition, size: CGSize(width: circleSize.size, height: circleSize.size))
        super.init(frame: circleFrame)
        
        self.backgroundColor = .gray
        self.layer.cornerRadius = self.frame.size.width/2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
