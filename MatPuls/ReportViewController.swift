//
//  ReportViewController.swift
//  MatPuls
//
//  Created by Toni Sučić on 23.11.2016.
//  Copyright © 2016 Toni Sučić. All rights reserved.
//

import UIKit
import RealmSwift
import PKHUD

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
        
        customerNameLabel.text = "\("customer".localized(comment: "Customer")): \(customer.name)"
        
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

        if report.coolers.count > 0 {
            let alert = UIAlertController(title: "report".localized(comment: "Report"), message: "reportActionMessage".localized(comment: "Generate a PDF-file or edit the report?"), preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "reportGeneratePDF".localized(comment: "Generate PDF"), style: .default) { _ in
                HUD.show(.progress)
                
                self.performSegue(withIdentifier: "pdfSegue", sender: report)
                
                tableView.deselectRow(at: indexPath, animated: true)
            })
            alert.addAction(UIAlertAction(title: "reportEdit".localized(comment: "Edit"), style: .default) { _ in
                self.performSegue(withIdentifier: "coolerSegue", sender: report)
                
                tableView.deselectRow(at: indexPath, animated: true)
            })
            alert.addAction(UIAlertAction(title: "cancel".localized(comment: "Cancel"), style: .cancel) { _ in
                tableView.deselectRow(at: indexPath, animated: true)
            })
            
            present(alert, animated: true, completion: nil)
        } else {
            self.performSegue(withIdentifier: "coolerSegue", sender: report)
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
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
