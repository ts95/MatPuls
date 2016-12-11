//
//  Item.swift
//  MatPuls
//
//  Created by Toni Sučić on 23.11.2016.
//  Copyright © 2016 Toni Sučić. All rights reserved.
//

import RealmSwift

class Item: Object {
    
    dynamic var unit = ""
    dynamic var placeMeasured = ""
    dynamic var temp = 0
    
    func prettyTemp(for cooler: Cooler) -> String {
        let baseString = String(format: "%d°C", arguments: [temp])
        
        if cooler.lowerTemp < 0 {
            return freezingCoolerStrategy(baseString: baseString, cooler: cooler)
        }
        
        return regularCoolerStrategy(baseString: baseString, cooler: cooler)
    }
    
    func freezingCoolerStrategy(baseString: String, cooler: Cooler) -> String {
        if temp > cooler.upperTemp + 4 {
            return "\(baseString) ☹️"
        }
        
        if temp > cooler.upperTemp {
            return "\(baseString) 😐"
        }
        
        return baseString
    }
    
    func regularCoolerStrategy(baseString: String, cooler: Cooler) -> String {
        if temp > cooler.upperTemp + 14 {
            return "\(baseString) 🚮"
        }
        
        if temp > cooler.upperTemp + 4 {
            return "\(baseString) ☹️"
        }
        
        if temp > cooler.upperTemp {
            return "\(baseString) 😐"
        }
        
        if temp < cooler.lowerTemp {
            return "\(baseString) 😐"
        }
        
        return baseString
    }
}
