//
//  Event.swift
//  bounce
//
//  Created by Alex Castillo on 11/15/18.
//  Copyright © 2018 Serbetcioglu. All rights reserved.
//

import Foundation
import Contacts

class Event{
    
    var name: String
    var date: Date
    var description: String
    var guestList: [Guest]
    // Class init with empty guest list
    init(name : String, descr : String, date: Date){
        self.name = name
        self.description = descr
        self.date = date
        self.guestList = []
    }
    // Class init with pre-populated guest list (for EditEvent calls)
    init(name: String, descr : String, date: Date, guestList : [Guest]){
        self.name = name
        self.description = descr
        self.date = date
        self.guestList = guestList
    }
    
    func hasGuest(contact : CNContact) -> Bool {
        let name = contact.givenName + " " + contact.familyName
        for guest in guestList{
            if (guest.name == name){
                return true
            }
        }
        return false
    }
}
