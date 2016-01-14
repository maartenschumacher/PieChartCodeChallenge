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

func currencyFormat(amount: Float) -> String {
    let formatter = NSNumberFormatter()
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