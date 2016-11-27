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
    
    var customer: Customer!
    var report: Report!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
}
