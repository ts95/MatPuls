//
//  PDFViewController.swift
//  MatPuls
//
//  Created by Toni Sučić on 10.12.2016.
//  Copyright © 2016 Toni Sučić. All rights reserved.
//

import UIKit
import MessageUI

class PDFViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    var customer: Customer!
    var report: Report!
    
    var pdfData: Data?
    
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
            
            self.pdfData = htmlToPdf!.pdFdata
        }, failure: { htmlToPdf in
            print("An error occured while generating the PDF.")
        })
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yy.MM.dd"
        
        let date = formatter.string(from: report.date as Date)
        
        let subject = "MatPuls rapport"
        
        mailComposerVC.setToRecipients([customer.email])
        mailComposerVC.setSubject(subject)
        mailComposerVC.setMessageBody("MatPuls rapport for \(customer.name). Dato: \(date)", isHTML: false)
        mailComposerVC.addAttachmentData(pdfData!, mimeType: "application/pdf", fileName: "MatPuls \(customer.name) rapport \(date).pdf")
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let alert = UIAlertController(title: "Eposten kunne ikke sendes", message: "Enheten din kunne ikke sende eposten. Sjekk om epostkonfigurasjonen din stemmer.?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func compose() {
        guard pdfData != nil else { return }
        
        let mailComposeViewController = configuredMailComposeViewController()
        
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    @IBAction func close() {
        dismiss(animated: true, completion: nil)
    }
}
