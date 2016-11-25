//
//  CustomerTableViewController.swift
//  MatPuls
//
//  Created by Toni Sučić on 23.11.2016.
//  Copyright © 2016 Toni Sučić. All rights reserved.
//

import UIKit
import RealmSwift

class CustomerTableViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var customers: Results<Customer>!
    var notificationToken: NotificationToken!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customers = realm.objects(Customer.self).sorted(byProperty: "name")

        notificationToken = customers.addNotificationBlock { changes in
            tableViewRealmChangeHandler(changes: changes, tableView: self.tableView)
        }
    }
    
    deinit {
        notificationToken.stop()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "customerCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CustomerCell
        
        let customer = customers[indexPath.row]
        
        cell.nameLabel.text = customer.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let customer = customers[indexPath.row]
        
        switch editingStyle {
        case .delete:
            try! realm.write {
                realm.delete(customer)
            }
            break
            
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "reportSegue", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "reportSegue":
            let dest = segue.destination as! ReportViewController
            dest.customer = customers[(sender as! Int)]
            break
            
        default:
            break
        }
        
    }
}
