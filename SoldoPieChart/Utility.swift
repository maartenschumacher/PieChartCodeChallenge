//
//  Utility.swift
//  SoldoPieChart
//
//  Created by Maarten Schumacher on 13/01/16.
//  Copyright © 2016 Maarten Schumacher. All rights reserved.
//

import UIKit

struct RGBColor {
    let r, g, b: Int
    
    var uiColor: UIColor {
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1.0)
    }
    
    var cgColor: CGColor {
        return uiColor.CGColor
    }
}

struct DiscreteRange<T: Comparable> {
    let start: T
    let end: T
}

func currencyFormat(amount: Float) -> String {
    let formatter = NSNumberFormatter()
    formatter.currencyCode = "GBP"
    formatter.numberStyle = .CurrencyStyle
    return formatter.stringFromNumber(amount)!
}

extension SequenceType {
    func scan<T>(initial: T, combine: (T, Self.Generator.Element) -> T) -> [T] {
        var state = initial
        var result = [T]()
        
        for element in self {
            let newState = combine(state, element)
            result.append(newState)
            state = newState
        }
        
        return result
    }
}

infix operator |> { associativity left }
func |> <T, U> (lhs: T, rhs: T -> U) -> U {
    return rhs(lhs)
}

extension NSAttributedString {
    func join(sequence: [NSAttributedString]) -> NSAttributedString {
        let mutableString = NSMutableAttributedString(attributedString: sequence[0])
        for index in 1 ..< sequence.count {
            mutableString.appendAttributedString(self)
            mutableString.appendAttributedString(sequence[index])
        }
        return NSAttributedString(attributedString: mutableString)
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