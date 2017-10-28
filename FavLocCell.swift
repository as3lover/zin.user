//
//  FavLocCell.swift
//  zin
//
//  Created by Morteza on 7/1/1396 AP.
//  Copyright © 1396 Pasys. All rights reserved.
//

import UIKit

class FavLocCell: UITableViewCell {
    
    
    @IBOutlet weak var locationTitle: UILabel!
    
    private var _favLoc:FavLoc?
    
    var favLoc:FavLoc?{
        get{
            return _favLoc
        }
        set(val){
            _favLoc = val
            locationTitle.text = _favLoc?.label
        }
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
