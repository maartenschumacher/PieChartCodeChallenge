//
//  ViewController.swift
//  SoldoPieChart
//
//  Created by Maarten Schumacher on 13/01/16.
//  Copyright © 2016 Maarten Schumacher. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pieView: PieView!
    
    var tableDataSource: UITableViewDataSource!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let data = parseData(mockData)
        
        pieView.viewModel = PieViewModel(segmentData: data.map {$0 as SegmentData})
        
        tableDataSource = data
            .map { $0 as ExpenseCellData }
            |> ExpenseTableDataSource.init
        
        tableView.dataSource = tableDataSource
        tableView.delegate = self
    }
}

class ExpenseTableDataSource: NSObject, UITableViewDataSource {
    let data: [ExpenseCellData]
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ReuseIdentifiers.ExpenseCell) as! ExpenseCell
        
        cell.dataSource = data[indexPath.row]
                
        return cell
    }
    
    init(data: [ExpenseCellData]) {
        self.data = data
    }
}