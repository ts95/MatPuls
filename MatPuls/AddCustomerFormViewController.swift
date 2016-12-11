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
        
        form +++ Section(header: "newCustomerHeader".localized(with: "Create a new customer"), footer: "newCustomerFooter".localized(with: "In order to create a report you need to create a customer first."))
            <<< NameRow() { row in
                var rules = RuleSet<String>()
                rules.add(rule: RuleRequired())
                rules.add(rule: RuleMinLength(minLength: 2))
                rules.add(rule: RuleMaxLength(maxLength: 40))
                
                row.tag = "name"
                row.title = "name".localized(with: "Name")
                row.placeholder = "namePlaceholder".localized(with: "Enter name")
                row.add(ruleSet: rules)
                row.validationOptions = .validatesOnChange
            }
            <<< EmailRow() { row in
                var rules = RuleSet<String>()
                rules.add(rule: RuleMinLength(minLength: 2))
                rules.add(rule: RuleMaxLength(maxLength: 40))
                rules.add(rule: RuleEmail())
                
                row.tag = "email"
                row.title = "email".localized(with: "Email")
                row.placeholder = "emailPlaceholder".localized(with: "Enter email")
                row.add(ruleSet: rules)
                row.validationOptions = .validatesOnChange
            }
    }
    
    @IBAction func done() {        
        let nameRow = form.rowBy(tag: "name") as! NameRow
        let emailRow = form.rowBy(tag: "email") as! EmailRow

        let passes = formErrorAlert(self, form: form)
        
        guard passes else { return }
        
        let realm = try! Realm()
        
        let customer = Customer()
        customer.name = nameRow.value!
        customer.email = emailRow.value!
        
        try! realm.write {
            realm.add(customer)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func close() {
        dismiss(animated: true, completion: nil)
    }
}
