//
//  SignedIntRow.swift
//  MatPuls
//
//  Created by Toni Sučić on 11.12.2016.
//  Copyright © 2016 Toni Sučić. All rights reserved.
//

import UIKit
import Eureka

open class SignedIntCell : _FieldCell<Int>, CellType {
    
    required public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func setup() {
        super.setup()
        
        textField.autocorrectionType = .default
        textField.autocapitalizationType = .none
        textField.keyboardType = .numbersAndPunctuation
    }
}

open class _SignedIntRow: FieldRow<SignedIntCell> {
    
    public required init(tag: String?) {
        super.init(tag: tag)
        
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale.current
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 0
        
        formatter = numberFormatter
    }
}

public final class SignedIntRow: _SignedIntRow, RowType {
    
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}
