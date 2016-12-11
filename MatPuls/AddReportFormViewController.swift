//
//  AddReportFormViewController.swift
//  MatPuls
//
//  Created by Toni Sučić on 25.11.2016.
//  Copyright © 2016 Toni Sučić. All rights reserved.
//

import UIKit
import Eureka
import RealmSwift

class AddReportFormViewController: FormViewController {
    
    let realm = try! Realm()

    var customer: Customer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ Section(header: "newReportHeader".localized(with: "Create a new report"), footer: "")
            <<< DateRow() { row in
                row.tag = "date"
                row.title = "date".localized(with: "Date")
                row.value = Date()
                row.validationOptions = .validatesOnChange
            }
    }
    
    @IBAction func done() {
        let dateRow = form.rowBy(tag: "date") as! DateRow
        
        let report = Report()
        report.date = dateRow.value! as NSDate
        
        try! realm.write {
            customer.reports.append(report)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel() {
        dismiss(animated: true, completion: nil)
    }
}
