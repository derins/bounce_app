//
//  MainPageViewController.swift
//  bounce
//
//  Created by Alex Castillo on 11/14/18.
//  Copyright © 2018 Serbetcioglu. All rights reserved.
/*
 */

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import Alamofire


class EventTableViewController: UITableViewController {
    // Consider adding a UUID to events to prevent names from messing up the DB
    let uid = Auth.auth().currentUser!.uid
    // Initialize Firestore db access and events list
    let db = Firestore.firestore()
    let sms = SMS()
    
    
    var events = [Event]()
    var selectedEvent : Event?
    var selectedEventIndex: Int?
    
    @IBOutlet var eventTableView: UITableView!
    
   
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings

        self.eventTableView.rowHeight = 110
        loadEvents()
        // Do any additional setup after loading the view.
    }
    
    // Returns the number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Returns the number of items in the table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    // Formatting for table view cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Dequeue the cell of interest
        //let cellIdentifier = "EventTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EventTableViewCell
        
        // Get item corresponding to indexPath & set the cell name label
        let item = events[indexPath.row]
        cell.eventNameLabel.text = item.name
        cell.eventDescriptionLabel.text = item.description
        
        // Format date and set the cell date label
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        let convertedDate = dateFormatter.string(from: item.date)
        cell.dateLabel.text = convertedDate
        
        return cell
    }
    
    @IBAction func unwindQRScan(segue: UIStoryboardSegue){
        
    }
    @IBAction func unwindCancel(segue: UIStoryboardSegue){
        // If cancel button is called (in either EditItem or AddItem views), do nothing
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Segue to EditEventVC when you click on an event
        self.selectedEvent = self.events[indexPath.row]
        self.selectedEventIndex = indexPath.row
        self.performSegue(withIdentifier: "editEvent", sender: self.selectedEvent)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editEvent" {
            let vc = segue.destination as! EditEventViewController
            let event = sender as! Event?
            vc.selectedEvent = event!
        }
        if segue.identifier == "segueToQRScanner" {
            let vc = segue.destination as! qrScannerViewController
            let event = sender as! Event
            vc.guestList = event.guestList
        }
    }
    
    @IBAction func unwindAddEvent(segue: UIStoryboardSegue){
        // If save is called from the AddItem view, we store the event locally and add a document to the Firestore database
        // We also write all the guest names to Firestore db
        // Then we reload data to update the tabelView
        if (segue.source is AddEventViewController){
            if let segueVC = segue.source as? AddEventViewController{
                let newItem = Event(name: segueVC.eventNameTextField.text!, descr: segueVC.eventDescriptionTextField.text!, date: segueVC.eventDatePicker.date, guestList: segueVC.guestList)
                
                self.db.collection("events").document(newItem.name + "_" + self.uid).setData([
                    "name": newItem.name,
                    "description": newItem.description,
                    "date": newItem.date,
                    "eventHost": self.uid
                    ])
                
                
                for guest in newItem.guestList{
                    
                    sms.sendText(WithGuest: guest, WithEvent: newItem)
                    
                    self.db.collection("guests").document(newItem.name + "_" + self.uid + "_" + guest.phoneNumber).setData([
                        "name": guest.name,
                        "phoneNumber": guest.phoneNumber,
                        "eventName": newItem.name,
                        "eventHost": self.uid,
                        "date": newItem.date
                        ])
                }
                
                events += [newItem]
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func unwindEditEvent(segue: UIStoryboardSegue){
        // If save is called from the EditEventVC, we need to delete the previous Firestore event document and the guests related to that event (this could be simplified if we used a static UUID for each event instead of using the event name as a key)
        // After deleting the documents from Firestore, we replace the event and then update the local TableView
        if (segue.source is EditEventViewController){
            if let segueVC = segue.source as? EditEventViewController{
                let newEvent = Event(name: segueVC.eventNameTextField.text!,
                                     descr: segueVC.eventDescriptionTextField.text!,
                                     date: segueVC.eventDatePicker.date,
                                     guestList: segueVC.selectedEvent.guestList)
                
                let addedGuests = segueVC.addedGuests
                for guest in addedGuests{
                    sms.sendText(WithGuest: guest, WithEvent: newEvent)
                }
                
                let oldEvent = self.events[self.selectedEventIndex!]
                
                // Delete the old document
                self.db.collection("events").document(oldEvent.name + "_" + self.uid).delete(){ err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Document successfully removed!")
                    }
                }
                
                // Delete the old guests
                for guest in oldEvent.guestList{
                    self.db.collection("guests").document(oldEvent.name + "_" + self.uid + "_" + guest.phoneNumber).delete(){ err in
                        if let err = err {
                            print("Error removing document: \(err)")
                        } else {
                            print("Document successfully removed!")
                        }
                    }
                    
                }
                // Write the new document
                self.db.collection("events").document(newEvent.name + "_" + self.uid).setData([
                    "name": newEvent.name,
                    "description": newEvent.description,
                    "date": newEvent.date,
                    "eventHost": self.uid
                    ])
                
                // Write the new guest list
                for guest in newEvent.guestList{
                    self.db.collection("guests").document(newEvent.name + "_" + self.uid + "_" + guest.phoneNumber).setData([
                        "name": guest.name,
                        "phoneNumber": guest.phoneNumber,
                        "eventName": newEvent.name,
                        "eventHost": self.uid,
                        "date": newEvent.date
                        ])
                }
                // Update the tableView
                self.events[self.selectedEventIndex!] = newEvent
                self.tableView.reloadData()
                
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func bounceButtonClicked(_ sender: Any) {
        guard let cell = (sender as AnyObject).superview?.superview as? EventTableViewCell else{
            return
        }
        let indexPath = tableView.indexPath(for: cell)
        performSegue(withIdentifier: "segueToQRScanner", sender: self.events[indexPath!.row])
    }
    
    func loadEvents(){
        self.db.collection("events").whereField("eventHost", isEqualTo: self.uid).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for eventDocument in querySnapshot!.documents {
                    let event_name = eventDocument.get("name") as! String
                    let event_description = eventDocument.get("description") as! String
                    let timestamp : Timestamp = eventDocument.get("date") as! Timestamp
                    let temp_event = Event(name: event_name,
                                           descr: event_description,
                                           date: timestamp.dateValue())
                    self.db.collection("guests").whereField("eventName", isEqualTo: temp_event.name).whereField("eventHost", isEqualTo: self.uid).getDocuments(){ (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for guestDocument in querySnapshot!.documents {
                                
                                print(guestDocument.get("name") as! String)
                                let temp_guest = Guest(n: guestDocument.get("name") as! String,
                                                       pN: guestDocument.get("phoneNumber") as! String)
                                print(temp_guest.name)
                                temp_event.guestList.append(temp_guest)
                            }
                            self.tableView.reloadData()
                        }
                    }
                    self.events.append(temp_event)
                    
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
}


