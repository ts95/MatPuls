//
//  Cooler.swift
//  MatPuls
//
//  Created by Toni Sučić on 23.11.2016.
//  Copyright © 2016 Toni Sučić. All rights reserved.
//

import RealmSwift

class Cooler: Object {
    
    dynamic var name = ""
    dynamic var upperTemp = 0
    dynamic var lowerTemp = 0
    
    var tempRange: String {
        get {
            if upperTemp == lowerTemp {
                return String(format: "%d°C", arguments: [lowerTemp])
            }
            
            return String(format: "%d — %d°C", arguments: [lowerTemp, upperTemp])
        }
    }
    
    let items = List<Item>()
}
