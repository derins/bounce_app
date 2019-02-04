//
//  GuestListTableViewCell.swift
//  bounce
//
//  Created by Alex Castillo on 11/29/18.
//  Copyright © 2018 Serbetcioglu. All rights reserved.
//

import UIKit

// Simple table view cell for viewing who was already invited
class GuestListTableViewCell: UITableViewCell {

    @IBOutlet weak var guestName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
