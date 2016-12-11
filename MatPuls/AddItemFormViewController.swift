//
//  AddItemFormViewController.swift
//  MatPuls
//
//  Created by Toni Sučić on 04.12.2016.
//  Copyright © 2016 Toni Sučić. All rights reserved.
//

import UIKit
import Eureka
import RealmSwift

class AddItemFormViewController: FormViewController {

    var cooler: Cooler!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ Section(header: "newMeasurementHeader".localized(with: "New measurement"), footer: "")
            <<< NameRow() { row in
                var rules = RuleSet<String>()
                rules.add(rule: RuleRequired())
                rules.add(rule: RuleMinLength(minLength: 2))
                rules.add(rule: RuleMaxLength(maxLength: 30))
                
                row.tag = "unit"
                row.title = "itemUnit".localized(with: "Unit")
                row.placeholder = "itemUnitPlaceholder".localized(with: "Enter unit name")
                row.add(ruleSet: rules)
                row.validationOptions = .validatesOnChange
            }
            <<< NameRow() { row in
                var rules = RuleSet<String>()
                rules.add(rule: RuleRequired())
                rules.add(rule: RuleMinLength(minLength: 2))
                rules.add(rule: RuleMaxLength(maxLength: 30))
                
                row.tag = "placeMeasured"
                row.title = "itemPlaceMeasured".localized(with: "Place measured")
                row.placeholder = "itemPlaceMeasuredPlaceholder".localized(with: "Enter measurement place")
                row.add(ruleSet: rules)
                row.validationOptions = .validatesOnChange
            }
            <<< SignedIntRow() { row in
                var rules = RuleSet<Int>()
                rules.add(rule: RuleRequired())
                
                row.tag = "temp"
                row.title = "itemTemp".localized(with: "Temperature")
                row.placeholder = "°C"
                row.add(ruleSet: rules)
                row.validationOptions = .validatesOnChange
            }
    }
    
    @IBAction func done() {
        let unitRow = form.rowBy(tag: "unit") as! NameRow
        let placeMeasuredRow = form.rowBy(tag: "placeMeasured") as! NameRow
        let tempRow = form.rowBy(tag: "temp") as! SignedIntRow
        
        let passes = formErrorAlert(self, form: form)
        
        guard passes else { return }
        
        let realm = try! Realm()
        
        let item = Item()
        item.unit = unitRow.value!
        item.placeMeasured = placeMeasuredRow.value!
        item.temp = tempRow.value!
        
        try! realm.write {
            cooler.items.append(item)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel() {
        dismiss(animated: true, completion: nil)
    }
}
