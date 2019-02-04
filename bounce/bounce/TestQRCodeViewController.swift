//
//  TestQRCodeViewController.swift
//  bounce
//
//  Created by Alex Castillo on 11/16/18.
//  Copyright © 2018 Serbetcioglu. All rights reserved.
//

import UIKit
import MessageUI
class TestQRCodeViewController: UIViewController, MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var QRCodeView: UIImageView!
    
    var image = UIImage(named:"qrImage")
    
    @IBOutlet weak var phoneNumberField: UITextField!
    
    @IBAction func generateQRCode(_ sender: Any) {
        let guest = Guest(n: "Alex Castillo", pN: phoneNumberField.text!)
        DispatchQueue.main.async {
            self.QRCodeView.image = guest.qrCodeImage
        }
        image = guest.qrCodeImage
        
        //let imageData: NSData = image!.pngData()! as NSData
        let composeVC = MFMessageComposeViewController()
        composeVC.messageComposeDelegate = self
        
        // Configure the fields of the interface.
        composeVC.recipients = [phoneNumberField.text!]
        composeVC.body = "Come celebrate thanmksgiving with us!"
        //composeVC.addAttachmentData((imageData as Data), typeIdentifier: "image/png", filename: "qrImage.png")
        
        // Present the view controller modally.
        if MFMessageComposeViewController.canSendText() {
            self.present(composeVC, animated: true, completion: nil)
        } else {
            print("Can't send messages.")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
//    func displayMessageInterface() {
//        let composeVC = MFMessageComposeViewController()
//        composeVC.messageComposeDelegate = self
//
//        // Configure the fields of the interface.
//        composeVC.recipients = [phoneNumberField.text!]
//        composeVC.body = guest.qrCodeImage
//
//        // Present the view controller modally.
//        if MFMessageComposeViewController.canSendText() {
//            self.present(composeVC, animated: true, completion: nil)
//        } else {
//            print("Can't send messages.")
//        }
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


}
