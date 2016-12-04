//
//  AddCoolerFormViewController.swift
//  MatPuls
//
//  Created by Toni Sučić on 27.11.2016.
//  Copyright © 2016 Toni Sučić. All rights reserved.
//

import UIKit
import Eureka
import RealmSwift

class AddCoolerFormViewController: FormViewController {
    
    var report: Report!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ Section(header: "Ny kjøler", footer: "En kjøler kan f.eks. være et kjølerom, en kjøledisk, en frysedisk eller et fryserom.")
            <<< TextRow() { row in
                var rules = RuleSet<String>()
                rules.add(rule: RuleRequired())
                rules.add(rule: RuleMinLength(minLength: 2))
                rules.add(rule: RuleMaxLength(maxLength: 20))
                
                row.tag = "name"
                row.title = "Navn"
                row.placeholder = "Angi kjølernavn"
                row.add(ruleSet: rules)
                row.validationOptions = .validatesOnChange
            }
        
        // TODO: Create TempRangeRow and TempRow rows
    }
    
    @IBAction func done() {
        let nameRow = form.rowBy(tag: "name") as! TextRow
        
        guard nameRow.validationErrors.count == 0 else { return }
        
        let realm = try! Realm()
        
        let cooler = Cooler()
        cooler.name = nameRow.value!
        cooler.tempRange = "2°C - 4°C"
        
        try! realm.write {
            report.coolers.append(cooler)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel() {
        dismiss(animated: true, completion: nil)
    }
}
