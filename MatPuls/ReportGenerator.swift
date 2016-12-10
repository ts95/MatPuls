//
//  ReportGenerator.swift
//  MatPuls
//
//  Created by Toni Sučić on 10.12.2016.
//  Copyright © 2016 Toni Sučić. All rights reserved.
//

import Foundation
import CoreGraphics
import RealmSwift
import Mustache
import iOS_htmltopdf

class ReportGenerator {
    
    static var pdfCreator: NDHTMLtoPDF!
    
    static func generatePDF(customer: Customer, report: Report, completion: @escaping NDHTMLtoPDFCompletionBlock, failure: @escaping NDHTMLtoPDFCompletionBlock) {
        let template = try! Template(named: "report")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yy.MM.dd"
        
        let data: [String:Any] = [
            "customer": customer.name,
            "date": formatter.string(from: report.date as Date),
            "coolers": Array(report.coolers.map { (cooler: Cooler) -> [String:Any] in
                return [
                    "name": cooler.name,
                    "tempRange": cooler.tempRange,
                    "items": Array(cooler.items.map { (item: Item) -> [String:Any] in
                        return [
                            "unit": item.unit,
                            "placeMeasured": item.placeMeasured,
                            "temp": item.prettyTemp(for: cooler),
                        ]
                    })
                ]
            })
        ]
        
        let html = try! template.render(data)
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let fileName = "\(documentsDirectory)/report.pdf"
        
        pdfCreator = NDHTMLtoPDF.createPDF(
            withHTML: html,
            baseURL: nil,
            pathForPDF: fileName,
            pageSize: CGSize(width: 595.2, height: 841.8),
            margins: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
            successBlock: completion,
            errorBlock: failure
        ) as! NDHTMLtoPDF
    }
}
