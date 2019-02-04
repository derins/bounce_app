//
//  ContactTableViewController.swift
//  bounce
//
//  Created by Alex Castillo on 11/28/18.
//  Copyright © 2018 Serbetcioglu. All rights reserved.
//

import UIKit
import MessageUI

class EditContactTableViewController: UITableViewController ,  MFMessageComposeViewControllerDelegate{
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    var contactList = [SelectableContact]()
    var event : Event!
    
    // Much the same as AddContactTableViewController, creates a FetchAllSelectableContacts object that will have a list of all contacts on the phone, then adds them to the local contactList field based on whether the event in question already has the guest on the guest list
    override func viewDidLoad() {
        super.viewDidLoad()
        let contactFetcher = FetchAllSelectableContacts()
        for contact in contactFetcher.contacts{
            if (!event.hasGuest(contact: contact.contact) &&
                (contact.contact.givenName != "" || contact.contact.familyName != "")
                && (!contact.hasSelected)){
                contactList.append(contact)
            }
        }
        
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
    
    
    @IBAction func invite_person(_ sender: Any) {
    }
    
    
    // Clicking a cell will highlight it as gray, clicking again will unhighlight
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
    
    // Selecting a row will make the SelectableContact object's "hasSelected" field equal to true
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        contactList[indexPath.row].hasSelected = !(contactList[indexPath.row].hasSelected)
        self.tableView.reloadData()
    }
    
    
    
    
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

