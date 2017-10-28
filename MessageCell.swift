//
//  MessageCell.swift
//  zin
//
//  Created by Morteza on 6/26/1396 AP.
//  Copyright © 1396 Pasys. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    

    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var icon: UIImageView!
    var messageText:String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        print("awakeFromNib")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
