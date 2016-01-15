//
//  PieView.swift
//  pietest
//
//  Created by Maarten Schumacher on 13/01/16.
//  Copyright © 2016 Maarten Schumacher. All rights reserved.
//

import UIKit

protocol SegmentData {
    var name: String { get }
    var color: RGBColor { get }
    var percentageRange: DiscreteRange<Float> { get }
    var amount: Float { get }
}

class PieView: UIView {
    @IBOutlet weak var amountLabel: UILabel!     
    var data: [SegmentData]!
    
    let circleWidth: CGFloat = 30.0
    
    var once: Bool = false
    
    var segmentLayers: [CAShapeLayer]? {
        didSet {
            segmentLayers?.forEach {
                self.layer.addSublayer($0)
            }
        }
    }
    
    override var bounds: CGRect {
        didSet {
            self.segmentLayers?.forEach {
                if let index = self.layer.sublayers?.indexOf($0) {
                    self.layer.sublayers?.removeAtIndex(index)
                }
            }
            
            self.segmentLayers = data.map { slice($0) }
            
            amountLabel.attributedText = totalAmountString
        }
    }
    
    var totalAmountString: NSAttributedString {
        return data
            .map { $0.amount }
            .reduce(0.0) { total, amount in
                total + amount
            }
            |> currencyFormat
            |> totalAmountFormat
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
    
    func totalAmountFormat(string: String) -> NSAttributedString {
        let components = string.componentsSeparatedByString(".")
        let attributes = [28.0, 18.0]
            .map { UIFont.systemFontOfSize($0) }
            .map { [ NSFontAttributeName : $0 ] }
        
        return zip(components, attributes)
            .map { component, attribute in
                NSAttributedString(string: component, attributes: attribute)
            }
            |> NSAttributedString(string: ".").join
    }
    
    func segmentAmountFormat(segment: SegmentData) -> String {
        return "\(segment.name): \n" + "\(currencyFormat(segment.amount))"
    }
    
    func segmentForLayer(layer: CAShapeLayer) -> SegmentData? {
        return segmentLayers?
            .indexOf(layer)
            .map { data[$0] }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let point = touches.first!.locationInView(self)
        
        segmentLayers?.forEach { layer in
            if CGPathContainsPoint(layer.path, nil, point, false) {
                amountLabel.text = (layer
                    |> segmentForLayer)
                    .map { segmentAmountFormat($0) }
                
                segmentLayers?.filter { $0 != layer }
                    .forEach { $0.opacity = 0.5 }
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        amountLabel.attributedText = totalAmountString
        segmentLayers?.forEach { $0.opacity = 1.0 }
    }
    
}

