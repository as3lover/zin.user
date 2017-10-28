//
//  ContactCell.swift
//  zin
//
//  Created by Morteza on 6/28/1396 AP.
//  Copyright © 1396 Pasys. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {
    
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var dateAndTime: UILabel!
    
    var messageText:String = ""

    //@IBOutlet weak var date: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
}
