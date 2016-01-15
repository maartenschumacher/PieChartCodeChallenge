//
//  CircleView.swift
//  SoldoPieChart
//
//  Created by Maarten Schumacher on 15/01/16.
//  Copyright © 2016 Maarten Schumacher. All rights reserved.
//

import UIKit

class CircleView: UIView {
    var touchBeganAtIndex: (Int -> ())!
    var touchEnded: (() -> ())!
    
    var data: [SegmentData] = []
    
    var segmentLayers: [CAShapeLayer]? {
        didSet {
            segmentLayers?.forEach {
                self.layer.addSublayer($0)
            }
        }
    }
    
    override var bounds: CGRect {
        didSet {
            makeSegments(data)
        }
    }
    
    func makeSegments(data: [SegmentData]) {
        self.segmentLayers?.forEach {
            if let index = self.layer.sublayers?.indexOf($0) {
                self.layer.sublayers?.removeAtIndex(index)
            }
        }
        
        self.segmentLayers = data.map { slice($0) }
    }
    
    func slice(data: SegmentData) -> CAShapeLayer {
        let slice = CAShapeLayer()
        
        slice.fillColor = data.color.cgColor
        slice.strokeColor = UIColor.blackColor().CGColor
        slice.lineWidth = 0.0
        slice.path = slicePath(data).CGPath
        
        return slice
    }
    
    func slicePath(data: SegmentData) -> UIBezierPath {
        let center = CGPointMake(self.bounds.width / 2.0, self.bounds.height / 2.0)
        let radius = self.bounds.height / 2.0
        let circleWidth = radius / 4
        
        let startAngle = degreesToRadians(CGFloat(data.percentageRange.start * 360.0 - 90.0))
        let endAngle = degreesToRadians(CGFloat(data.percentageRange.end * 360.0 - 90.0))
        
        let startOuterPoint = CGPointMake(center.x + radius * cosf(startAngle), center.y + radius * sinf(startAngle))
        let endInnerPoint = CGPointMake(center.x + (radius - circleWidth) * cosf(endAngle), center.y + (radius - circleWidth) * sinf(endAngle))
        
        let path = UIBezierPath()
        path.moveToPoint(startOuterPoint)
        path.addArcWithCenter(center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        path.addLineToPoint(endInnerPoint)
        path.addArcWithCenter(center, radius: radius - circleWidth, startAngle: endAngle, endAngle: startAngle, clockwise: false)
        path.addLineToPoint(startOuterPoint)
        
        return path
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let point = touches.first!.locationInView(self)
        
        segmentLayers?.enumerate().forEach { index, layer in
            if CGPathContainsPoint(layer.path, nil, point, false) {
                touchBeganAtIndex(index)
                segmentLayers?.filter { $0 != layer }
                    .forEach { $0.opacity = 0.5 }
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touchEnded()
        segmentLayers?.forEach { $0.opacity = 1.0 }
    }
}
