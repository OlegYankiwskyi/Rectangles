//
//  ViewController.swift
//  Rectangles
//
//  Created by OlegMac on 6/27/19.
//  Copyright © 2019 Oleg_Yankivskyi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    private var point: CircleView?
    private var rectangleInDrawing: RectangleView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupGestureRecognizer()
        self.view.backgroundColor = .cyan
    }

    private func setupGestureRecognizer() {
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGesture))
        
        self.view.addGestureRecognizer(tapRecognizer)
        self.view.addGestureRecognizer(panRecognizer)
    }
    
    @objc private func tap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: nil)
        
        if let point = self.point {
            let rectangle = self.createRectangle(point.center, location)
            if !rectangle.isProperSize {
                rectangle.removeFromSuperview()
                self.showIndicator()
            }
        }
        else {
            self.createCircle(position: location)
        }
    }
    
    @objc private func panGesture(_ sender: UIPanGestureRecognizer) {
        let position = sender.location(in: nil)

        switch sender.state {
            
        case .began:
            self.rectangleInDrawing = self.createRectangle(position, position)
            
        case .changed:
            guard let rectangle = self.rectangleInDrawing else { return }
            
            rectangle.redraw(secondPoint: position)
        default:
            guard let rectangle = self.rectangleInDrawing else { return }
            
            if !rectangle.isProperSize {
                rectangle.removeFromSuperview()
            }
            self.rectangleInDrawing = nil
        }
    }
    
    private func showIndicator() {
        self.view.backgroundColor = .red
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.view.backgroundColor = .cyan
        }
    }
    
    private func createCircle(position: CGPoint) {
        
        self.hideSpotsOnRectangles()
        let circleView = CircleView(position: position)
        self.point = circleView
        self.view.addSubview(circleView)
    }
    
    private func createRectangle(_ firstPoint: CGPoint, _ secondPoint: CGPoint) -> RectangleView {
        
        self.hideSpotsOnRectangles()
        let rectangle = RectangleView(firstPoint: firstPoint, secondPoint: secondPoint)
        rectangle.delegate = self
        self.point?.removeFromSuperview()
        self.view.addSubview(rectangle)
        self.point = nil
        return rectangle
    }
    
    private func hideSpotsOnRectangles() {
        
        self.view.subviews.forEach {
            ($0 as? RectangleView)?.hideSpots()
        }
    }
}

extension ViewController: RectangleDelegate {
    
    func moveToTop(_ view: UIView) {
        
        self.point?.removeFromSuperview()
        self.point = nil
        self.hideSpotsOnRectangles()
        self.view.bringSubviewToFront(view)
    }
}
