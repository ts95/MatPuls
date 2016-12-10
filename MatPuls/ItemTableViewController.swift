//
//  ItemTableViewController.swift
//  MatPuls
//
//  Created by Toni Sučić on 04.12.2016.
//  Copyright © 2016 Toni Sučić. All rights reserved.
//

import UIKit
import Eureka
import RealmSwift

class ItemTableViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var notificationToken: NotificationToken!
    
    var report: Report!
    var cooler: Cooler!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationToken = cooler.items.addNotificationBlock { changes in
            tableViewRealmChangeHandler(changes: changes, tableView: self.tableView)
        }
    }
    
    deinit {
        notificationToken.stop()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cooler.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "itemCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ItemCell
        
        let item = cooler.items[indexPath.row]
        
        cell.unit.text = item.unit
        cell.placeMeasured.text = item.placeMeasured
        cell.temp.text = item.prettyTemp(for: cooler)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let item = cooler.items[indexPath.row]
        
        switch editingStyle {
        case .delete:
            try! realm.write {
                realm.delete(item)
            }
            break
            
        default:
            break
        }
    }
    
    @IBAction func add() {
        performSegue(withIdentifier: "addItemSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier != nil else { return }
        
        switch segue.identifier! {
        case "addItemSegue":
            let nav = segue.destination as! UINavigationController
            let dest = nav.topViewController as! AddItemFormViewController
            dest.cooler = cooler
            break
            
        default:
            break
        }
    }
}
