//
//  Customer.swift
//  MatPuls
//
//  Created by Toni Sučić on 23.11.2016.
//  Copyright © 2016 Toni Sučić. All rights reserved.
//

import UIKit
import RealmSwift

class Customer: Object {
    
    dynamic var name = ""
    let reports = List<Report>()
}
