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
    
    var notificationToken: NotificationToken!
    
    var customer: Customer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reportTableView.delegate = self
        reportTableView.dataSource = self
        
        customerNameLabel.text = "Rapporter for \(customer.name)"
        
        notificationToken = customer.reports.addNotificationBlock { changes in
            tableViewRealmChangeHandler(changes: changes, tableView: self.reportTableView)
        }
        
        print("There are \(customer.reports.count) report(s)")
    }
    
    deinit {
        notificationToken.stop()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customer.reports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifer = "reportCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifer, for: indexPath) as! ReportCell
        
        let report = customer.reports[indexPath.row]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy, MMM d"
        
        cell.dateLabel.text = formatter.string(from: report.date as Date)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let report = customer.reports[indexPath.row]
        
        switch editingStyle {
        case .delete:
            try! realm.write {
                realm.delete(report)
            }
            break
            
        default:
            break
        }
    }
    
    @IBAction func addReport() {
        performSegue(withIdentifier: "addReportSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier != nil else { return }
        
        switch segue.identifier! {
        case "addReportSegue":
            let nav = segue.destination as! UINavigationController
            let dest = nav.topViewController as! AddReportFormViewController
            dest.customer = customer
            break
            
        default:
            break
        }
        
    }
}
