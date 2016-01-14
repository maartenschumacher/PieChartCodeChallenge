//
//  PieView.swift
//  pietest
//
//  Created by Maarten Schumacher on 13/01/16.
//  Copyright © 2016 Maarten Schumacher. All rights reserved.
//

import UIKit

class PieView: UIView {
    weak var amountLabel: UILabel!
    var dataSource: ChartDataSource?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addAmountLabel()
    }
    
    func addAmountLabel() {
        let label = UILabel(frame: CGRectZero)
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        self.addConstraints([
            NSLayoutConstraint(item: label, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: label, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0),
        ])
        
        self.amountLabel = label
    }
    
    override func layoutSublayersOfLayer(layer: CALayer) {
        if let data = self.dataSource {
            addLayers(data)
            configureAmountLabel(data)
            amountLabel.layoutIfNeeded()
        }
    }
    
    func configureAmountLabel(data: ChartDataSource) {
        amountLabel.textColor = Colors.Grey.uiColor
        amountLabel.attributedText = data
            .segments
            .map { $0.amount }
            .reduce(0.0) { total, amount in
                total + amount
            }
            |> currencyFormat
            |> totalAmountFormat
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
        slice.fillColor = UIColor.clearColor().CGColor
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

