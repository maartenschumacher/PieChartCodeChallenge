//
//  MockData.swift
//  SoldoPieChart
//
//  Created by Maarten Schumacher on 13/01/16.
//  Copyright © 2016 Maarten Schumacher. All rights reserved.
//

import Foundation

let mockData = [
    FakeFetchedExpense(name: "Food", iconName: ImageAssetNames.FoodIcon, amount: 292.40, color: Colors.Blue),
    FakeFetchedExpense(name: "Clothing", iconName: ImageAssetNames.ClothingIcon, amount: 131.50, color: Colors.Red),
    FakeFetchedExpense(name: "Airlines", iconName: ImageAssetNames.AirlinesIcon, amount: 70.30, color: Colors.Green),
    FakeFetchedExpense(name: "Hotel", iconName: ImageAssetNames.HotelIcon, amount: 58.48, color: Colors.Yellow),
    FakeFetchedExpense(name: "Entertainment", iconName: ImageAssetNames.EntertainmentIcon, amount: 29.12, color: Colors.Grey)
]

struct FakeFetchedExpense {
    let name: String
    let iconName: String
    let amount: Float
    let color: RGBColor
}

func parseData(expenses: [FakeFetchedExpense]) -> [Expense] {
    let totalAmount = expenses
        .reduce(0.0) { amount, expense in
            amount + expense.amount
        }
    
    let sortedExpenses = expenses
        .sort { $0.amount > $1.amount }
    
    let percentages = sortedExpenses
        .map { expense in
            expense.amount / totalAmount
        }
    
    let percentageRanges = percentages
        .scan(DiscreteRange(start: 0.0, end: 0.0)) { range, percentage in
            DiscreteRange(
                start: range.end,
                end: range.end + percentage
            )
        }
    
    return zip3(expenses, b: percentages, c: percentageRanges)
        .map { expense, percentage, percentageRange in
            Expense(
                name: expense.name,
                iconName: expense.iconName,
                amount: expense.amount,
                percentage: percentage,
                percentageRange: percentageRange,
                color: expense.color
            )
        }
}