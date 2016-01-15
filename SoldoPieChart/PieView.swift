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

protocol PieViewData {
    var segmentData: [SegmentData] { get }
    var totalAmountString: NSAttributedString { get }
    func amountTextForSegment(segment: SegmentData) -> String
}

class PieView: UIView {
    @IBOutlet weak var circleView: CircleView!
    @IBOutlet weak var amountLabel: UILabel!
    
    var viewModel: PieViewData! {
        didSet {
            configureCircleView()
            amountLabel.attributedText = viewModel.totalAmountString
        }
    }
    
    func configureCircleView() {
        circleView.touchBeganAtIndex = { [weak self] index in
            if let weakSelf = self {
                weakSelf.amountLabel.text = weakSelf.viewModel.segmentData[index]
                    |> weakSelf.viewModel.amountTextForSegment
            }
        }
        
        circleView.touchEnded = { [weak self] _ in
            if let weakSelf = self {
                weakSelf.amountLabel.attributedText = weakSelf.viewModel.totalAmountString
            }
        }
        
        circleView.data = viewModel.segmentData
    }
}

