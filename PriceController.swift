//
//  PriceController.swift
//  zin
//
//  Created by Morteza on 6/9/1396 AP.
//  Copyright © 1396 Pasys. All rights reserved.
//

import UIKit
import MapKit

class PriceController: UIViewController {
    
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var origin: UITextField!
    
    @IBOutlet weak var dest: UITextField!

    
    
    
    var vc:MapContoller!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    @IBAction func addOrigin(_ sender: Any) {
        addPlace(origin, vc.originLoc)
    }
    
    @IBAction func addDest(_ sender: Any) {
        addPlace(dest, vc.destLoc)
    }
    
    
    func addPlace(_ title:UITextField, _ location:CLLocationCoordinate2D)
    {
        
        var lable:String? = title.text
        if lable == nil
        {
            lable = ""
        }
        
        var address:String? = title.placeholder
        if address == nil
        {
            address = "مکان بدون نام"
        }
        
        func complete(_ status:PostStatus)
        {
            MainView.vc?.inProgress = false
            
            if status == .Yes
            {
                var message = "به فهرست مکان های مورد علاقه اضافه شد"
                if (lable! != address!)
                {
                    message = "آدرس «" + address! + "» با نام «" + lable! + "» " + message
                }
                else
                {
                    message = "آدرس «" + address! + "» " + message
                }
                
                MainView.vc?.Alert(message, "", "OK")
            }
            else
            {
                MainView.vc?.Alert("خطا در اتصال به سرور", "", "OK")
            }

        }
        
        func lertComplete(_ newLable:String)
        {
            MainView.vc?.inProgress = true
            if newLable != ""
            {
                lable = newLable
                title.text = newLable
            }
            else
            {
                lable = address!
            }
            
            Requests.saveLocation(address!, lable!, location, complete)
        }
        
        
        MainView.vc?.AlertInput(message: "Enter Label", title: "Add To Fav", cancel: "cancel", save: "save", placeHolder: address!, fieldText: lable!, function: lertComplete)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func load()
    {
        if (self.origin.placeholder != vc.origin.text!)
        {
            self.origin.placeholder = vc.origin.text!
            self.origin.text = ""
        }
        
        if (self.dest.placeholder != vc.dest.text!)
        {
            self.dest.placeholder = vc.dest.text!
            self.dest.text = ""
        }
        
    }
    
    
    
    
    @IBAction func onClose(_ sender: Any) {
        
        vc.hidePrice()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
