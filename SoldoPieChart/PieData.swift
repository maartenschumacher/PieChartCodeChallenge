//
//  PieData.swift
//  pietest
//
//  Created by Maarten Schumacher on 13/01/16.
//  Copyright © 2016 Maarten Schumacher. All rights reserved.
//

import UIKit

protocol SegmentData {
    var color: RGBColor { get }
    var percentageRange: DiscreteRange<Float> { get }
    var amount: Float { get }
}

struct DiscreteRange<T: Comparable> {
    let start: T
    let end: T
}


