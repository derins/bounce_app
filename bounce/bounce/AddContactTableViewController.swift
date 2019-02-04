//
//  ContactTableViewController.swift
//  bounce
//
//  Created by Alex Castillo on 11/28/18.
//  Copyright © 2018 Serbetcioglu. All rights reserved.
//

import UIKit

class AddContactTableViewController: UITableViewController {
    var contactList = [SelectableContact]()
    var event : Event!
    
    // on load, we create a new selectable contact class and append them to the local selectableContact array based on whether or not they are already in the event guest list
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let contactFetcher = FetchAllSelectableContacts()
        for contact in contactFetcher.contacts{
            // Show guest on table view only if they're not already part of the event
            if (!event.hasGuest(contact: contact.contact) &&
                (contact.contact.givenName != "" || contact.contact.familyName != "")
                && (!contact.hasSelected)){
                contactList.append(contact)
            }
        }
        // Sort contacts by name
        contactList.sort {$0.contact.givenName < $1.contact.givenName}
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return contactList.count
    }

    // Clicking a contact makes them be highlighted as gray
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ContactTableViewCell
        let item = contactList[indexPath.row]
        if (item.hasSelected){
            cell.backgroundColor = UIColor.lightGray
        }
        else{
            cell.backgroundColor = UIColor.white
        }
        cell.contactNameLabel.text = item.contact.givenName + " " + item.contact.familyName
        
        return cell
    }
    
    // If we click on a table view cell, it sets the SelectableContact object's "hasSelected" bool field to true, clicking again sets it to false
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        contactList[indexPath.row].hasSelected = !(contactList[indexPath.row].hasSelected )
        self.tableView.reloadData()
    }
    
    
   
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "saveAddContactsSegue" {
            let vc = segue.destination as! EventTableViewController
            let cList = sender as! [SelectableContact]
            for con in cList{
                if (con.hasSelected){
                    self.event.guestList.append(Guest(contact: con.contact))
                }
            }
            if (self.creatingNewEvent){
                vc.events.append(self.event)
            }
            else{
                vc.events[vc.selectedEventIndex!] = self.event
            }
        }
        if segue.identifier == "cancelAddContactsSegue" {
            let vc = segue.destination as! EventTableViewController
            if (self.creatingNewEvent){
                vc.events.append(self.event)
            }
            else{
                vc.events[vc.selectedEventIndex!] = self.event
            }
        }
        
        
    }
 */
   
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
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
