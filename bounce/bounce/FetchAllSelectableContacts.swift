//
//  FetchAllSelectableContacts.swift
//  bounce
//
//  Created by Alex Castillo on 11/28/18.
//  Copyright © 2018 Serbetcioglu. All rights reserved.
//

import Foundation
import Contacts

// Class for fetching contacts from your phone
class FetchAllSelectableContacts{
    // Selectable contacts are just the CNContact object and a boolean for "isSelected"
    var contacts = [SelectableContact]()
    
    
    init(){
         let store = CNContactStore()
        store.requestAccess(for: .contacts) { (granted, err) in
            if let err = err{
                print("Failed to request access:", err)
                return
            }
            if granted {
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                do {
                    
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointerIfYouWantToStopEnumerating) in
                        // Create selectable contact object and append to list
                        self.contacts.append(SelectableContact(contact: contact, hasSelected: false))
                    })
                    

                } catch let err {
                    print("Failed to enumerate contacts:", err)
                }
            }
        }
    }
    
    
    
    
}
struct SelectableContact {
    let contact: CNContact
    var hasSelected: Bool
}
