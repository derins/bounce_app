//
//  SMS.swift
//  bounce
//
//  Created by Alex Castillo on 12/4/18.
//  Copyright © 2018 Serbetcioglu. All rights reserved.
//


import Foundation
import UIKit
import Alamofire

class SMS{
    let accountSID = "AC0aefd3b7fd761baff8c25d33825427c4"
    let authToken = "82dca14b3407e26ae4efaf194bf3efa1"
    
    init(){
        
    }
    func sendText(WithGuest: Guest, WithEvent : Event){
        let parameters = ["From": "4752758118", "To": WithGuest.phoneNumber, "Body": "You are invited to " + WithEvent.name + ", click the link to access your QR Code: " + "https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=" + WithGuest.phoneNumber]
        let url = "https://api.twilio.com/2010-04-01/Accounts/\(self.accountSID)/Messages"
        
        Alamofire.request(url, method: .post, parameters: parameters)
            .authenticate(user: self.accountSID, password: self.authToken)
            .responseString{ response in
                debugPrint(response)
        }
        
    }
    
    
    
    /*
     let base64String = imageData!.base64EncodedString(options: .lineLength64Characters)
     let parameters = ["From": "4752758118", "To": guest.phoneNumber, "Body": "You are invited to " + event.name + ", here is your QR Code: "]
     */
    
    /*
     let url = "https://api.twilio.com/2010-04-01/Accounts/\(self.accountSID)/Messages"
     let parameters = ["From": "4752758118", "To": guest.phoneNumber, "Body": "You are invited to " + newItem.name + ", here is your QR Code: "]
     //let image = guest.qrCodeImage
     
     
     Alamofire.request(url, method: .post, parameters: parameters)
     .authenticate(user: self.accountSID, password: self.authToken)
     .responseString{ response in
     debugPrint(response)
     }
     */
    
    
    
    
}
