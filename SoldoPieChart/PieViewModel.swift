//
//  PieViewModel.swift
//  SoldoPieChart
//
//  Created by Maarten Schumacher on 15/01/16.
//  Copyright © 2016 Maarten Schumacher. All rights reserved.
//

import UIKit

struct PieViewModel: PieViewData {
    let segmentData: [SegmentData]
    
    var totalAmountString: NSAttributedString {
        return segmentData
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
    
    func amountTextForSegment(segment: SegmentData) -> String {
        return "\(segment.name): \n" + "\(currencyFormat(segment.amount))"
    }
}