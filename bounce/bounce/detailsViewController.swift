//
//  detailsViewController.swift
//  bounce
//
//  Created by Derin Serbetcioglu on 12/4/18.
//  Copyright © 2018 Serbetcioglu. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

   
    @IBOutlet weak var statusLabel: UILabel!
    var scanResult : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        if (self.scanResult){
            statusLabel.text = "Guest approved."
        }
        else{
            statusLabel.text = "Guest not found on list."
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
