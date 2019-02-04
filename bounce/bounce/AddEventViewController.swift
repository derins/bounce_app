//
//  AddEventViewController.swift
//  bounce
//
//  Created by Alex Castillo on 11/16/18.
//  Copyright © 2018 Serbetcioglu. All rights reserved.
//

import UIKit

class AddEventViewController: UIViewController, UITextFieldDelegate {

  
    
   
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var eventDescriptionTextField: UITextField!
    @IBOutlet weak var eventDatePicker: UIDatePicker!
    
    
    
    var guestList = [Guest]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.eventNameTextField.delegate = self
        self.eventDescriptionTextField.delegate = self

        // Do any additional setup after loading the view.
    }
    
    // Clicking return closes the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Preparation or segue to add guests VC
        if segue.identifier == "addEventInviteGuests" {
            let vc = segue.destination as! AddContactTableViewController
            vc.event = Event(name: self.eventNameTextField.text!, descr: self.eventDescriptionTextField.text!, date: self.eventDatePicker.date, guestList: self.guestList)
        }
    }
    // Clicking cancel from the addContactVC should unwind without making any changes
    @IBAction func unwindCancelAddContactToAddEvent(segue: UIStoryboardSegue){
    }
    
    // If we click save from the addContactVC, we append the new guests to the event and unwind
    @IBAction func unwindSaveAddContactToAddEvent(segue: UIStoryboardSegue){
        if (segue.source is AddContactTableViewController){
            if let segueVC = segue.source as? AddContactTableViewController{
                for pGuest in segueVC.contactList{
                    if (pGuest.hasSelected){
                        guestList.append(Guest(contact: pGuest.contact))
                    }
                }
            }
        }
    }
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createEventAndInvite" {
            let vc = segue.destination as! ContactTableViewController
            vc.event = Event(name: self.eventNameTextField.text!, descr: self.eventDescriptionTextField.text!, date: self.eventDatePicker.date)
            vc.creatingNewEvent = true
        }
        
    }
 */
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
