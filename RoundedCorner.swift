//
//  RoundedCorner.swift
//  zin
//
//  Created by Morteza on 5/25/1396 AP.
//  Copyright © 1396 Pasys. All rights reserved.
//

import UIKit

class RoundedCorner: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 7
        self.clipsToBounds = true
    }

}
