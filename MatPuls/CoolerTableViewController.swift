//
//  CoolerTableViewController.swift
//  MatPuls
//
//  Created by Toni Sučić on 27.11.2016.
//  Copyright © 2016 Toni Sučić. All rights reserved.
//

import UIKit
import RealmSwift

class CoolerTableViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var notificationToken: NotificationToken!
    
    var customer: Customer!
    var report: Report!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationToken = report.coolers.addNotificationBlock { changes in
            tableViewRealmChangeHandler(changes: changes, tableView: self.tableView)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return report.coolers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "coolerCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CoolerCell
        
        let cooler = report.coolers[indexPath.row]
        
        cell.name.text = cooler.name
        cell.tempRange.text = cooler.tempRange
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = report.coolers[indexPath.row]
        
        performSegue(withIdentifier: "itemSegue", sender: item)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let cooler = report.coolers[indexPath.row]
        
        switch editingStyle {
        case .delete:
            try! realm.write {
                realm.delete(cooler)
            }
            break
            
        default:
            break
        }
    }
    
    @IBAction func add() {
        performSegue(withIdentifier: "addCoolerSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier != nil else { return }
        
        switch segue.identifier! {
        case "itemSegue":
            let dest = segue.destination as! ItemTableViewController
            dest.report = report
            dest.cooler = sender as! Cooler
            break
            
        case "addCoolerSegue":
            let nav = segue.destination as! UINavigationController
            let dest = nav.topViewController as! AddCoolerFormViewController
            dest.report = report
            break
            
        default:
            break
        }
    }
}
