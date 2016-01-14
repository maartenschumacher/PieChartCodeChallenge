//
//  PieView.swift
//  pietest
//
//  Created by Maarten Schumacher on 13/01/16.
//  Copyright © 2016 Maarten Schumacher. All rights reserved.
//

import UIKit

@IBDesignable
class PieView: UIView {
    @IBOutlet weak var amountLabel: UILabel!
    
    func setData(data: [SegmentData]) {
        self.layer.sublayers?.removeAll()
        addLayers(data)
        configureAmountLabel(data)
    }
    
    func configureAmountLabel(segments: [SegmentData]) {
        amountLabel.textColor = Colors.Grey.uiColor
        amountLabel.attributedText = segments
            .map { $0.amount }
            .reduce(0.0) { total, amount in
                total + amount
            }
            |> currencyFormat
            |> totalAmountFormat
    }
    
    func addLayers(data: [SegmentData]) {
        data.map { slice($0) }
            .forEach { slice in
                self.layer.addSublayer(slice)
            }
    }
    
    func slice(data: SegmentData) -> CAShapeLayer {
        let slice = CAShapeLayer()
        
        slice.fillColor = UIColor.clearColor().CGColor
        slice.strokeColor = data.color.cgColor
        slice.lineWidth = 30.0 /// IMPROVE
        slice.path = slicePath(data).CGPath
        
        return slice
    }
    
    func slicePath(data: SegmentData) -> UIBezierPath {
        let startAngle = CGFloat(data.percentageRange.start * 360.0 - 90.0)
        let endAngle = CGFloat(data.percentageRange.end * 360.0 - 90.0)
        
        let center = CGPointMake(self.bounds.width / 2.0, self.bounds.height / 2.0)
        let radius = self.bounds.height / 2.0 - 15
        
        let path = UIBezierPath()
        path.addArcWithCenter(center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
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
}

