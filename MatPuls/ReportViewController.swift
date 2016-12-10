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
        
        customerNameLabel.text = "Kunde: \(customer.name)"
        
        notificationToken = customer.reports.addNotificationBlock { changes in
            tableViewRealmChangeHandler(changes: changes, tableView: self.reportTableView)
        }
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
        formatter.dateStyle = .long
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let report = customer.reports[indexPath.row]
        
        let alert = UIAlertController(title: "Rapport", message: "Generere PDF-fil eller redigere rapporten?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "PDF", style: .default) { alertAction in
            self.performSegue(withIdentifier: "pdfSegue", sender: report)
        })
        alert.addAction(UIAlertAction(title: "Redigere", style: .default) { alertAction in
            self.performSegue(withIdentifier: "coolerSegue", sender: report)
        })
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addReport() {
        performSegue(withIdentifier: "addReportSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier != nil else { return }
        
        switch segue.identifier! {
        case "coolerSegue":
            let dest = segue.destination as! CoolerTableViewController
            dest.customer = customer
            dest.report = sender as! Report
            break
            
        case "addReportSegue":
            let nav = segue.destination as! UINavigationController
            let dest = nav.topViewController as! AddReportFormViewController
            dest.customer = customer
            break
            
        case "pdfSegue":
            let nav = segue.destination as! UINavigationController
            let dest = nav.topViewController as! PDFViewController
            dest.customer = customer
            dest.report = sender as! Report
            break
            
        default:
            break
        }
    }
}
