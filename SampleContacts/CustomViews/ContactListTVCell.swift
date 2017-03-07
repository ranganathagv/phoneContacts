//
//  ContactListTVCell.swift
//  SampleContacts
//
//  Created by Ranganatha Veeranagappa on 3/7/17.
//  Copyright © 2017 Ranganatha Veeranagappa. All rights reserved.
//

import UIKit

class ContactListTVCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var contactNameLbl: UILabel!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
