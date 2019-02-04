//
//  Guest.swift
//  bounce
//
//  Created by Alex Castillo on 11/16/18.
//  Copyright © 2018 Serbetcioglu. All rights reserved.
//

import Foundation
import ContactsUI

class Guest{
    var name: String
    var phoneNumber: String
    var qrCodeImage: UIImage
    
    // Guest initializer with contact object
    init(contact: CNContact){
        name = contact.givenName + " " + contact.familyName
        phoneNumber = (contact.phoneNumbers[0].value ).value(forKey: "digits") as! String
        phoneNumber = phoneNumber.replacingOccurrences(of: "+", with: "")
        // Generate QRCode
        let data = phoneNumber.data(using: String.Encoding.ascii)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter!.setValue(data, forKey: "inputMessage")
        let output = filter!.outputImage?.transformed(by: CGAffineTransform(scaleX: 9, y: 9))
        qrCodeImage =  UIImage(ciImage: output!)
    }
    
    // Guest initializer for pulling from Firestore
    init(n: String, pN: String){
        name = n
        phoneNumber = pN
        // Generate QRCode
        let data = phoneNumber.data(using: String.Encoding.ascii)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter!.setValue(data, forKey: "inputMessage")
        let output = filter!.outputImage?.transformed(by: CGAffineTransform(scaleX: 9, y: 9))
        qrCodeImage =  UIImage(ciImage: output!)
    }
    
}

