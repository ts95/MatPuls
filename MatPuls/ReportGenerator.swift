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
        
        /*let data: [String:Any] = [
            "customer": customer.name,
            "date": formatter.string(from: report.date as Date),
            "coolers": report.coolers.map { (cooler: Cooler) -> [String:Any] in
                return [
                    "name": cooler.name,
                    "tempRange": String(format: "%.1f - %.1f°C", arguments: [cooler.lowerTemp, cooler.upperTemp]),
                    "items": cooler.items.map { (item: Item) -> [String:Any] in
                        return [
                            "unit": item.unit,
                            "placeMeasured": item.placeMeasured,
                            "temp": item.temp,
                        ]
                    }
                ]
            }
        ]*/
        
        let data: [String:Any] = [
            "customer": "McDonald's i Gjøvik",
            "date": "14.12.16",
            "coolers": [
                [
                    "name": "Some cooler",
                    "tempRange": "1 - 5°C",
                    "items": [
                        [
                            "unit": "Some unit",
                            "placeMeasured": "Some place",
                            "temp": "1°C"
                        ],
                        [
                            "unit": "Some unit",
                            "placeMeasured": "Some place",
                            "temp": "4°C"
                        ],
                        [
                            "unit": "Some unit",
                            "placeMeasured": "Some place",
                            "temp": "3°C"
                        ],
                        [
                            "unit": "Some unit",
                            "placeMeasured": "Some place",
                            "temp": "9°C ☹️"
                        ]
                    ]
                ],
                [
                    "name": "Some other cooler",
                    "tempRange": "1 - 4°C",
                    "items": [
                        [
                            "unit": "Some unit",
                            "placeMeasured": "Some place",
                            "temp": "4°C"
                        ],
                        [
                            "unit": "Some unit",
                            "placeMeasured": "Some place",
                            "temp": "2°C"
                        ],
                        [
                            "unit": "Some unit",
                            "placeMeasured": "Some place",
                            "temp": "5°C 😐"
                        ],
                        [
                            "unit": "Some unit",
                            "placeMeasured": "Some place",
                            "temp": "3°C"
                        ]
                    ]
                ],
                [
                    "name": "Some other cooler",
                    "tempRange": "1 - 4°C",
                    "items": [
                        [
                            "unit": "Some unit",
                            "placeMeasured": "Some place",
                            "temp": "4°C"
                        ],
                        [
                            "unit": "Some unit",
                            "placeMeasured": "Some place",
                            "temp": "2°C"
                        ],
                        [
                            "unit": "Some unit",
                            "placeMeasured": "Some place",
                            "temp": "5°C 😐"
                        ],
                        [
                            "unit": "Some unit",
                            "placeMeasured": "Some place",
                            "temp": "3°C"
                        ]
                    ]
                ],
                [
                    "name": "Some other cooler",
                    "tempRange": "1 - 4°C",
                    "items": [
                        [
                            "unit": "Some unit",
                            "placeMeasured": "Some place",
                            "temp": "4°C"
                        ],
                        [
                            "unit": "Some unit",
                            "placeMeasured": "Some place",
                            "temp": "2°C"
                        ],
                        [
                            "unit": "Some unit",
                            "placeMeasured": "Some place",
                            "temp": "5°C 😐"
                        ],
                        [
                            "unit": "Some unit",
                            "placeMeasured": "Some place",
                            "temp": "3°C"
                        ]
                    ]
                ]
            ]
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
            margins: UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5),
            successBlock: completion,
            errorBlock: failure
        ) as! NDHTMLtoPDF
    }
}
