//
//  ModelTests.swift
//  ModelTests
//
//  Created by Toni Sučić on 23.11.2016.
//  Copyright © 2016 Toni Sučić. All rights reserved.
//

import XCTest
import RealmSwift
@testable import MatPuls

class ModelTests: XCTestCase {
    
    let realm = try! Realm()
    
    let fridgeCooler = Cooler()
    let freezerCooler = Cooler()
    let meatItem = Item()
    
    override func setUp() {
        super.setUp()
        
        fridgeCooler.upperTemp = 4
        fridgeCooler.lowerTemp = 1
        
        freezerCooler.lowerTemp = -18
        freezerCooler.upperTemp = -18
        
        meatItem.unit = "Kjøtt"
        meatItem.placeMeasured = "Luft"
        meatItem.temp = 0
        
        try! realm.write {
            realm.add(fridgeCooler)
            freezerCooler.items.append(meatItem)
            fridgeCooler.items.append(meatItem)
        }
    }
    
    override func tearDown() {
        super.tearDown()
        
        try! realm.write {
            realm.delete(fridgeCooler)
        }
    }
    
    func testPrettyTemp() {
        // Fridge strategy
        
        XCTAssertEqual(meatItem.prettyTemp(for: fridgeCooler), "0°C 😐")

        try! realm.write {
            meatItem.temp = 4
        }
        
        XCTAssertEqual(meatItem.prettyTemp(for: fridgeCooler), "4°C")
        
        try! realm.write {
            meatItem.temp = 8
        }
        
        XCTAssertEqual(meatItem.prettyTemp(for: fridgeCooler), "8°C 😐")
        
        try! realm.write {
            meatItem.temp = 9
        }
        
        XCTAssertEqual(meatItem.prettyTemp(for: fridgeCooler), "9°C ☹️")
        
        try! realm.write {
            meatItem.temp = 19
        }
        
        XCTAssertEqual(meatItem.prettyTemp(for: fridgeCooler), "19°C 🚮")
        
        // Freezer strategy
        
        try! realm.write {
            meatItem.temp = -13
        }
        
        XCTAssertEqual(meatItem.prettyTemp(for: freezerCooler), "-13°C ☹️")
        
        try! realm.write {
            meatItem.temp = -17
        }
        
        XCTAssertEqual(meatItem.prettyTemp(for: freezerCooler), "-17°C 😐")
        
        try! realm.write {
            meatItem.temp = -18
        }
        
        XCTAssertEqual(meatItem.prettyTemp(for: freezerCooler), "-18°C")
        
        try! realm.write {
            meatItem.temp = -20
        }
        
        XCTAssertEqual(meatItem.prettyTemp(for: freezerCooler), "-20°C")
    }
}
