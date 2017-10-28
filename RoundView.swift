//
//  RoundView.swift
//  zin
//
//  Created by Morteza on 5/26/1396 AP.
//  Copyright © 1396 Pasys. All rights reserved.
//

import UIKit

extension UIView {
    
    func roundView(radious:CGFloat)
    {
        self.layer.cornerRadius = radious
        self.clipsToBounds = true
    }
    
    func roundView()
    {
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }
    
    var cornerRadius: CGFloat {
        set {
            roundView(radious: newValue)
        }
        get{
            return self.layer.cornerRadius
        }
    }
    
    var cornered: Bool {
        set {
            if self.layer.cornerRadius == 0
            {
                self.layer.cornerRadius = 5
            }
            self.clipsToBounds = newValue
        }
        get{
            return (self.clipsToBounds && self.layer.cornerRadius > 0)
        }
    }

}
