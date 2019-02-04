//
//  EventDetailsViewController.swift
//  bounce
//
//  Created by Alex Castillo on 11/28/18.
//  Copyright © 2018 Serbetcioglu. All rights reserved.
//

import UIKit

class EditEventViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var eventDescriptionTextField: UITextField!
    @IBOutlet weak var eventDatePicker: UIDatePicker!
    
    var addedGuests = [Guest]()
    var selectedEvent : Event!
    
    // Prepopulate fields for this VC
    override func viewDidLoad() {
        super.viewDidLoad()
        eventNameTextField.text = selectedEvent.name
        eventDescriptionTextField.text = selectedEvent.description
        eventDatePicker.date = selectedEvent.date
        self.eventNameTextField.delegate = self
        self.eventDescriptionTextField.delegate = self
        
    }
    
    // Typing enter should hide the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // preparation for inviting guests
        if segue.identifier == "editEventInviteGuests" {
            let vc = segue.destination as! EditContactTableViewController
            vc.event = Event(name: self.eventNameTextField.text!, descr: self.eventDescriptionTextField.text!, date: self.eventDatePicker.date, guestList: selectedEvent.guestList)
        }
        // Preparation for showing the current guest list
        if segue.identifier == "showGuests" {
            let vc = segue.destination as! GuestListTableViewController
            vc.guestList = self.selectedEvent.guestList
        }
    }
    // Canceling from addContactVC does nothing
    @IBAction func unwindCancelAddContactToEditEvent(segue: UIStoryboardSegue){
    }
    
    // If we save the new contacts, we add them to the current event
    @IBAction func unwindSaveAddContactToEditEvent(segue: UIStoryboardSegue){
        if (segue.source is EditContactTableViewController){
            if let segueVC = segue.source as? EditContactTableViewController{
                for pGuest in segueVC.contactList{
                    if (pGuest.hasSelected){
                        self.selectedEvent.guestList.append(Guest(contact: pGuest.contact))
                        self.addedGuests.append(Guest(contact: pGuest.contact))
                        print("Saving contacts to list")
                    }
                }
            }
        }
    }
    // We shouldn't be able to make any changes from the "ShowGuestListVC"
    @IBAction func unwindShowGuestList(segue: UIStoryboardSegue){
    }
    
    
    //let eventName = eventNameTextField.text
    // let eventDescription = eventDescriptionTextField.text
    // returnToMainPage
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
