//
//  Expense.swift
//  SoldoPieChart
//
//  Created by Maarten Schumacher on 13/01/16.
//  Copyright © 2016 Maarten Schumacher. All rights reserved.
//

import UIKit


struct Expense: ExpenseCellData, SegmentData {
    let name: String
    let iconName: String
    let amount: Float
    let percentage: Float
    let percentageRange: DiscreteRange<Float>
    let color: RGBColor
}

