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
        
        form +++ Section(header: "Ny måling", footer: "")
            <<< NameRow() { row in
                var rules = RuleSet<String>()
                rules.add(rule: RuleRequired())
                rules.add(rule: RuleMinLength(minLength: 2))
                rules.add(rule: RuleMaxLength(maxLength: 30))
                
                row.tag = "unit"
                row.title = "Enhet"
                row.placeholder = "Angi enhetsnavn"
                row.add(ruleSet: rules)
                row.validationOptions = .validatesOnChange
            }
            <<< NameRow() { row in
                var rules = RuleSet<String>()
                rules.add(rule: RuleRequired())
                rules.add(rule: RuleMinLength(minLength: 2))
                rules.add(rule: RuleMaxLength(maxLength: 30))
                
                row.tag = "placeMeasured"
                row.title = "Sted målt"
                row.placeholder = "Angi målingssted"
                row.add(ruleSet: rules)
                row.validationOptions = .validatesOnChange
            }
            <<< SignedIntRow() { row in
                var rules = RuleSet<Int>()
                rules.add(rule: RuleRequired())
                
                row.tag = "temp"
                row.title = "Temperatur"
                row.placeholder = "°C"
                row.add(ruleSet: rules)
                row.validationOptions = .validatesOnChange
            }
    }
    
    @IBAction func done() {
        let unitRow = form.rowBy(tag: "unit") as! NameRow
        let placeMeasuredRow = form.rowBy(tag: "placeMeasured") as! NameRow
        let tempRow = form.rowBy(tag: "temp") as! SignedIntRow
        
        guard unitRow.validationErrors.count == 0 else { return }
        guard placeMeasuredRow.validationErrors.count == 0 else { return }
        guard tempRow.validationErrors.count == 0 else { return }
        
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
