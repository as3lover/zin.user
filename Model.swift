//
//  Model.swift
//  zin
//
//  Created by Morteza on 6/8/1396 AP.
//  Copyright © 1396 Pasys. All rights reserved.
//

import UIKit

class Model: UIView {

    static func stringToImage(_ name:String, _ w:Double, _ h:Double)-> UIImage?
    {
        let pinImage = UIImage(named: name)
        let newSize = CGSize(width: w, height: h)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        pinImage?.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }

}
