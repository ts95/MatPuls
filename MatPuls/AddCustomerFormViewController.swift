//
//  AddCustomerFormViewController.swift
//  MatPuls
//
//  Created by Toni Sučić on 23.11.2016.
//  Copyright © 2016 Toni Sučić. All rights reserved.
//

import UIKit
import Eureka
import RealmSwift

class AddCustomerFormViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ Section(header: "Opprett en ny kunde", footer: "Før man kan opprette en rapport må man opprette en kunde, da alle rapporter er forbundet med en kunde.")
            <<< TextRow() { row in
                var rules = RuleSet<String>()
                rules.add(rule: RuleRequired())
                rules.add(rule: RuleMinLength(minLength: 2))
                rules.add(rule: RuleMaxLength(maxLength: 20))
                
                row.tag = "name"
                row.title = "Navn"
                row.placeholder = "Angi navn"
                row.add(ruleSet: rules)
                row.validationOptions = .validatesOnChange
            }
    }
    
    @IBAction func close() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done() {
        let nameRow = form.rowBy(tag: "name") as! TextRow
        
        guard nameRow.validationErrors.count == 0 else { return }
        
        let realm = try! Realm()
        
        let customer = Customer()
        customer.name = nameRow.value!
        
        try! realm.write {
            realm.add(customer)
        }
        
        dismiss(animated: true, completion: nil)
    }
}
