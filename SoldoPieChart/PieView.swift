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
    @IBOutlet weak var circleView: CircleView!
    @IBOutlet weak var amountLabel: UILabel!
    var data: [SegmentData]!
    
    override var bounds: CGRect {
        didSet {
            configureCircleView()
            amountLabel.attributedText = totalAmountString
        }
    }
    
    func configureCircleView() {
        circleView.touchBeganAtIndex = { [weak self] index in
            if let weakSelf = self {
                weakSelf.amountLabel.text = weakSelf.data[index]
                    |> weakSelf.segmentAmountFormat
            }
        }
        
        circleView.touchEnded = { [weak self] _ in
            if let weakSelf = self {
                weakSelf.amountLabel.attributedText = weakSelf.totalAmountString
            }
        }
        
        circleView.makeSegments(data)
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
    
}

