//
//  TempRow.swift
//  MatPuls
//
//  Created by Toni Sučić on 28.11.2016.
//  Copyright © 2016 Toni Sučić. All rights reserved.
//

import UIKit
import Eureka
import RealmSwift

class Temp: Object {
    
    var temp: Double!
    
    override var description: String {
        return "\(temp)°C"
    }
}

class TempCell: _FieldCell<String>, CellType {
    
    required public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func setup() {
        super.setup()
        
        textField.autocorrectionType = .default
        textField.autocapitalizationType = .sentences
        textField.keyboardType = .default
    }
}

class _TempRow: FieldRow<TempCell> {
    
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}

final class TempRow: _TempRow, RowType {
    
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}
