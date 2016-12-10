//
//  PDFViewController.swift
//  MatPuls
//
//  Created by Toni Sučić on 10.12.2016.
//  Copyright © 2016 Toni Sučić. All rights reserved.
//

import UIKit

class PDFViewController: UIViewController {
    
    var customer: Customer!
    var report: Report!
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ReportGenerator.generatePDF(customer: customer, report: report, completion: { htmlToPdf in
            self.webView.load(
                htmlToPdf!.pdFdata,
                mimeType: "application/pdf",
                textEncodingName: "utf-8",
                baseURL: URL(string: "/pdf")!
            )
        }, failure: { htmlToPdf in
            print("An error occured while generating the PDF.")
        })
    }
    
    @IBAction func compose() {
        
    }
    
    @IBAction func close() {
        dismiss(animated: true, completion: nil)
    }
}
