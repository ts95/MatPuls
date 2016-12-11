//
//  Helper.swift
//  MatPuls
//
//  Created by Toni Sučić on 23.11.2016.
//  Copyright © 2016 Toni Sučić. All rights reserved.
//

import UIKit
import Eureka
import RealmSwift

func tableViewRealmChangeHandler<T>(changes: RealmCollectionChange<T>, tableView: UITableView?) {
    guard let tableView = tableView else { return }
    
    switch changes {
    case .initial:
        // Results are now populated and can be accessed without blocking the UI
        tableView.reloadData()
        break
    case .update(_, let deletions, let insertions, let modifications):
        // Query results have changed, so apply them to the UITableView
        tableView.beginUpdates()
        tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                             with: .automatic)
        tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                             with: .automatic)
        tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                             with: .automatic)
        tableView.endUpdates()
        break
    case .error(let error):
        // An error occurred while opening the Realm file on the background worker thread
        fatalError("\(error)")
        break
    }
}

func formErrorAlert(_ vc: UIViewController, form: Form) -> Bool {
    var messages: [String] = []

    for row in form.allRows {
        let validationErrors = row.validate()
        
        if validationErrors.count > 0 {
            messages.append(row.validate().reduce("\(row.title!):", { l, r
                in "\(l)\n\(r.msg.localized(with: "Validation error message"))"
            }) + "\n")
        }
    }
    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = NSTextAlignment.left
    
    let messageText = NSMutableAttributedString(
        string: messages.joined(separator: "\n").trimmingCharacters(in: CharacterSet.whitespacesAndNewlines),
        attributes: [
            NSParagraphStyleAttributeName: paragraphStyle,
            NSFontAttributeName : UIFont.preferredFont(forTextStyle: UIFontTextStyle.body),
            NSForegroundColorAttributeName : UIColor.black
        ]
    )
    
    let passes = messages.count == 0
    
    if !passes {
        let alert = UIAlertController(title: "error".localized(with: "Error"), message: "", preferredStyle: .alert)
        alert.setValue(messageText, forKey: "attributedMessage")
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    return messages.count == 0
}

extension String {
    func localized(with comment: String) -> String {
        return NSLocalizedString(self, comment: comment)
    }
}
