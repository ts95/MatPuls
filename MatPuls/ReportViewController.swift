//
//  ReportViewController.swift
//  MatPuls
//
//  Created by Toni Sučić on 23.11.2016.
//  Copyright © 2016 Toni Sučić. All rights reserved.
//

import UIKit
import RealmSwift

class ReportViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var reportTableView: UITableView!

    let realm = try! Realm()
    
    var customer: Customer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reportTableView.delegate = self
        
        customerNameLabel.text = "Rapporter for \(customer.name)"
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customer.reports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifer = "reportCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifer, for: indexPath) as! ReportCell
        
        let report = customer.reports[indexPath.row]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy, MMM d, HH:mm"
        
        cell.dateLabel.text = formatter.string(from: report.date as Date)
        
        return cell
    }
}
