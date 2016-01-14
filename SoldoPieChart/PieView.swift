//
//  PieView.swift
//  pietest
//
//  Created by Maarten Schumacher on 13/01/16.
//  Copyright © 2016 Maarten Schumacher. All rights reserved.
//

import UIKit

class PieView: UIView {
    var dataSource: ChartDataSource?
        
    override func layoutSublayersOfLayer(layer: CALayer) {
        if let data = self.dataSource {
            addLayers(data)
        }
    }
    
    func addLayers(data: ChartDataSource) {
        data.segments
            .map { slice($0) }
            .forEach { slice in
                self.layer.addSublayer(slice)
            }
    }
    
    func slice(data: SegmentData) -> CAShapeLayer {
        let slice = CAShapeLayer()
        slice.fillColor = UIColor.whiteColor().CGColor
        slice.strokeColor = data.color.cgColor
        slice.lineWidth = 30.0 /// IMPROVE
        
        let startAngle = CGFloat(data.percentageRange.start * 360.0 - 90.0)
        let endAngle = CGFloat(data.percentageRange.end * 360.0 - 90.0)

        let center = CGPointMake(self.bounds.width / 2.0, self.bounds.height / 2.0)
        let radius = self.bounds.height / 2.0 - 15
        
        let slicePath = circularPath(center, radius: radius, startAngle: degreesToRadians(startAngle), endAngle: degreesToRadians(endAngle))
        
        slice.path = slicePath.CGPath
        
        return slice
    }
    
    func circularPath(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        path.addArcWithCenter(center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        return path
    }
}

func degreesToRadians(float: CGFloat) -> CGFloat {
    return float * CGFloat(M_PI) / 180.0
}

func cosf(float: CGFloat) -> CGFloat {
    return CGFloat(cosf(Float(float)))
}

func sinf(float: CGFloat) -> CGFloat {
    return CGFloat(sinf(Float(float)))
}