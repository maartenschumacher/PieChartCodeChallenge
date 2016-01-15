//
//  ExpenseCell.swift
//  SoldoPieChart
//
//  Created by Maarten Schumacher on 13/01/16.
//  Copyright © 2016 Maarten Schumacher. All rights reserved.
//

import UIKit

class ExpenseCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    var dataSource: ExpenseCellData!
    
    override func layoutSubviews() {
        icon.image = UIImage(named: dataSource.iconName)
        nameLabel.text = dataSource.name
        amountLabel.text = currencyFormat(dataSource.amount)
        percentageLabel.text = "\(Int(dataSource.percentage * 100))%"
        
        progressView.progressTintColor = dataSource.color.uiColor
        progressView.trackTintColor = UIColor.whiteColor()
        progressView.progressViewStyle = .Bar
        //progressView.setProgress(dataSource.percentage, animated: true)
        UIView.animateWithDuration(1.0) {
            self.progressView.setProgress(self.dataSource.percentage, animated: true)
        }
    }
}

protocol ExpenseCellData {
    var iconName: String { get }
    var color: RGBColor { get }
    var name: String { get }
    var amount: Float { get }
    var percentage: Float { get }
}

