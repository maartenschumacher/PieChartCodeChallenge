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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        icon.image = UIImage(named: dataSource.iconName)
        nameLabel.text = dataSource.name
        amountLabel.text = "£ \(currencyFormat(dataSource.amount))"
        percentageLabel.text = "\(Int(dataSource.percentage)) %"
        
        progressView.progressTintColor = dataSource.color.uiColor
        progressView.trackTintColor = UIColor.whiteColor()
        progressView.setProgress(dataSource.percentage / 100.0, animated: true)
    }
    
}

protocol ExpenseCellData {
    var iconName: String { get }
    var color: RGBColor { get }
    var name: String { get }
    var amount: Float { get }
    var percentage: Float { get }
}

