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
            <<< NameRow() { row in
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
            <<< SignedIntRow() { row in
                var rules = RuleSet<Int>()
                rules.add(rule: RuleRequired())
                
                row.tag = "lowerTemp"
                row.title = "Min temperatur"
                row.placeholder = "°C"
                row.add(ruleSet: rules)
                row.validationOptions = .validatesOnChange
            }
            <<< SignedIntRow() { row in
                var rules = RuleSet<Int>()
                rules.add(rule: RuleRequired())

                row.tag = "upperTemp"
                row.title = "Maks temperatur"
                row.placeholder = "°C"
                row.add(ruleSet: rules)
                row.validationOptions = .validatesOnChange
            }
    }
    
    @IBAction func done() {
        let nameRow = form.rowBy(tag: "name") as! NameRow
        let lowerTempRow = form.rowBy(tag: "lowerTemp") as! SignedIntRow
        let upperTempRow = form.rowBy(tag: "upperTemp") as! SignedIntRow

        let passes = formErrorAlert(self, form: form)
        
        guard passes else { return }
        guard lowerTempRow.value! <= upperTempRow.value! else { return }
        
        let realm = try! Realm()
        
        let cooler = Cooler()
        cooler.name = nameRow.value!
        cooler.lowerTemp = lowerTempRow.value!
        cooler.upperTemp = upperTempRow.value!
        
        try! realm.write {
            report.coolers.append(cooler)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel() {
        dismiss(animated: true, completion: nil)
    }
}
