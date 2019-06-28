//
//  CircleView.swift
//  Rectangles
//
//  Created by OlegMac on 6/27/19.
//  Copyright © 2019 Oleg_Yankivskyi. All rights reserved.
//

import Foundation
import UIKit

class RectangleView: UIView {
    
    var delegate: RectangleDelegate?
    
    private var dragPosition: CGPoint?
    private var currentCropAreaPart: CropAreaPart?
    private let initialPoint: CGPoint
    
    var isProperSize: Bool {
        get {
            return self.frame.width > AppConfig.minSize && self.frame.height > AppConfig.minSize
        }
    }

    init(firstPoint: CGPoint, secondPoint: CGPoint) {
        self.initialPoint = firstPoint
        super.init(frame: CGRect())
        self.redraw(firstPoint: firstPoint, secondPoint: secondPoint)
        
        self.backgroundColor = .random()
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 3
        self.setupGestureRecognizer()
    }
    
    func redraw(firstPoint: CGPoint? = nil, secondPoint: CGPoint) {
        
        self.setFrame(firstPoint: firstPoint ?? self.initialPoint, secondPoint: secondPoint)
        self.layer.borderColor = self.isProperSize ? UIColor.black.cgColor : UIColor.red.cgColor
    }
    
    private func setupGestureRecognizer() {
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        self.addGestureRecognizer(tapRecognizer)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        longPressRecognizer.minimumPressDuration = 0.1
        self.addGestureRecognizer(longPressRecognizer)
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTap))
        doubleTapRecognizer.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTapRecognizer)
        
        tapRecognizer.require(toFail: doubleTapRecognizer)
        self.isUserInteractionEnabled = true
    }
    
    @objc private func doubleTap() {
        
        self.removeFromSuperview()
    }
    
    @objc private func longPress(_ sender: UILongPressGestureRecognizer) {
        let position = sender.location(in: nil)
        self.setAsTopView()
        
        switch sender.state {
            
        case .began:
            self.handleBeginingDrag(position: position)
            
        case .changed:
            self.handleEdit(position: position)
            
        default:
            break
        }
    }
    
    private func handleBeginingDrag(position: CGPoint) {
        
        self.dragPosition = position
        self.currentCropAreaPart = self.getCropAreaPartContainsPoint(position)
        self.backgroundColor = .random()
    }
    
    private func handleEdit(position: CGPoint) {
        guard let cropAreaPart = self.currentCropAreaPart else { return }
        
        let x: CGFloat
        let y: CGFloat
        let width: CGFloat
        let height: CGFloat
        
        switch cropAreaPart {
            
        case .topLeftCorner:
            width = self.frame.maxX - position.x
            height = self.frame.height * (width / self.frame.width)
            x = self.frame.minX + self.frame.width - width
            y = self.frame.minY + self.frame.height - height
            
        case .topRightCorner:
            width = position.x - self.frame.minX
            height = self.frame.height * (width / self.frame.width)
            x = self.frame.minX
            y = self.frame.minY + self.frame.height - height
            
        case .bottomLeftCorner:
            width = self.frame.maxX - position.x
            height = self.frame.height * (width / self.frame.width)
            x = position.x
            y = self.frame.minY
            
        case .bottomRightCorner:
            width = position.x - self.frame.minX
            height = self.frame.height * (width / self.frame.width)
            x = self.frame.minX
            y = self.frame.minY
            
        case .topEdge:
            width = self.frame.width
            height = self.frame.maxY - position.y
            x = self.frame.minX
            y = position.y
            
        case .leftEdge:
            width = self.frame.maxX - position.x
            height = self.frame.height
            x = position.x
            y = self.frame.minY
            
        case .bottomEdge:
            width = self.frame.width
            height = position.y - self.frame.minY
            x = self.frame.minX
            y = self.frame.minY
            
        case .rightEdge:
            width = position.x - self.frame.minX
            height = self.frame.height
            x = self.frame.minX
            y = self.frame.minY
            
        default: //Drag
            guard let dragPosition = self.dragPosition else { return }
            
            x = dragPosition.x - position.x
            y = dragPosition.y - position.y
            self.dragPosition = position
            self.moveTo(x: x, y: y)
            return
        }
        
        if width > AppConfig.minSize && height > AppConfig.minSize {
            
            self.frame = CGRect(x: x, y: y, width: width, height: height)
        }
    }
    
    private func rotate(angle: CGFloat) {
        
        self.transform = CGAffineTransform(rotationAngle: angle)
    }
    
    private func setAsTopView() {
        
        self.delegate?.moveToTop(self)
    }
    
    private func moveTo(x: CGFloat, y: CGFloat) {
        
        let x = self.frame.minX - x
        let y = self.frame.minY - y
        self.frame = CGRect(x: x, y: y, width: self.frame.width, height: self.frame.height)
    }
    
    @objc private func tap(_ sender: UITapGestureRecognizer) {

        self.setAsTopView()
    }
    
    private func setFrame(firstPoint: CGPoint, secondPoint: CGPoint) {
        
        let x = firstPoint.x < secondPoint.x ? firstPoint.x : secondPoint.x
        let y = firstPoint.y < secondPoint.y ? firstPoint.y : secondPoint.y
        let width = abs(firstPoint.x - secondPoint.x)
        let height = abs(firstPoint.y - secondPoint.y)
        
        self.frame = CGRect(x: x, y: y, width: width, height: height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RectangleView {

    private var cropAreaTopLeftCornerFrame: CGRect {
        return CGRect(
            origin: CGPoint(
                x: self.frame.origin.x - AppConfig.cornerTouchSize.width / 2,
                y: self.frame.origin.y - AppConfig.cornerTouchSize.height / 2),
            size: AppConfig.cornerTouchSize)
    }

    private var cropAreaTopRightCornerFrame: CGRect {
        return CGRect(
            origin: CGPoint(
                x: self.frame.maxX - AppConfig.cornerTouchSize.width / 2,
                y: self.frame.minY - AppConfig.cornerTouchSize.height / 2),
            size: AppConfig.cornerTouchSize)
    }

    private var cropAreaBottomLeftCornerFrame: CGRect {
        return CGRect(
            origin: CGPoint(
                x: self.frame.origin.x - AppConfig.cornerTouchSize.width / 2,
                y: self.frame.maxY - AppConfig.cornerTouchSize.height / 2),
            size: AppConfig.cornerTouchSize)
    }

    private var cropAreaBottomRightCornerFrame: CGRect {
        return CGRect(
            origin: CGPoint(
                x: self.frame.maxX - AppConfig.cornerTouchSize.width / 2,
                y: self.frame.maxY - AppConfig.cornerTouchSize.height / 2),
            size: AppConfig.cornerTouchSize)
    }

    private var cropAreaTopEdgeFrame: CGRect{
        return CGRect(
            x       : self.cropAreaTopLeftCornerFrame.maxX,
            y       : self.frame.origin.y - AppConfig.edgeTouchThickness.horizontal / 2,
            width   : self.frame.size.width - (cropAreaTopLeftCornerFrame.size.width / 2 + cropAreaTopRightCornerFrame.size.width / 2),
            height  : AppConfig.edgeTouchThickness.horizontal)
    }

    private var cropAreaBottomEdgeFrame: CGRect {
        return CGRect(
            x       : self.cropAreaBottomLeftCornerFrame.maxX,
            y       : self.frame.maxY - AppConfig.edgeTouchThickness.horizontal / 2,
            width   : self.frame.size.width - (cropAreaBottomLeftCornerFrame.size.width / 2 + cropAreaBottomRightCornerFrame.size.width / 2),
            height  : AppConfig.edgeTouchThickness.horizontal)
    }

    private var cropAreaRightEdgeFrame: CGRect {
        return CGRect(
            x       : self.frame.maxX - AppConfig.edgeTouchThickness.vertical / 2,
            y       : self.cropAreaTopLeftCornerFrame.maxY,
            width   : AppConfig.edgeTouchThickness.vertical,
            height  : self.frame.size.height - (cropAreaTopRightCornerFrame.size.height / 2 + cropAreaBottomRightCornerFrame.size.height / 2))
    }

    private var cropAreaLeftEdgeFrame: CGRect {
        return CGRect(
            x       : self.frame.origin.x - AppConfig.edgeTouchThickness.vertical / 2,
            y       : self.cropAreaTopLeftCornerFrame.maxY,
            width   : AppConfig.edgeTouchThickness.vertical,
            height  : self.frame.size.height - (cropAreaTopLeftCornerFrame.size.height / 2 + cropAreaBottomLeftCornerFrame.size.height / 2))
    }

    private func getCropAreaPartContainsPoint(_ point: CGPoint) -> CropAreaPart {
        if self.cropAreaTopEdgeFrame.contains(point) {
            return .topEdge
        } else if self.cropAreaBottomEdgeFrame.contains(point) {
            return .bottomEdge
        } else if self.cropAreaRightEdgeFrame.contains(point) {
            return .rightEdge
        } else if self.cropAreaLeftEdgeFrame.contains(point) {
            return .leftEdge
        } else if self.cropAreaTopLeftCornerFrame.contains(point) {
            return .topLeftCorner
        } else if self.cropAreaTopRightCornerFrame.contains(point) {
            return .topRightCorner
        } else if self.cropAreaBottomLeftCornerFrame.contains(point) {
            return .bottomLeftCorner
        } else if self.cropAreaBottomRightCornerFrame.contains(point) {
            return .bottomRightCorner
        } else {
            return .none
        }
    }
}

fileprivate enum CropAreaPart {
    case none
    case topEdge
    case leftEdge
    case bottomEdge
    case rightEdge
    case topLeftCorner
    case topRightCorner
    case bottomLeftCorner
    case bottomRightCorner
}
