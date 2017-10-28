//
//  DriverController.swift
//  zin.user
//
//  Created by NIC on 10/25/17.
//  Copyright © 2017 pasys. All rights reserved.
//

import UIKit

class DriverController: UIViewController {
    
    var vc:MapContoller!
    var VIEW:UIView?
    var service:Service!

    
    
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var carText: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Started")
        //view.backgroundColor = UIColor.clear
        view.isOpaque = false
        
        //VIEW = self.view
        
        load(service)
    }
    
    func load(_ service:Service)
    {
        print("Load")
        let s = service;
        
        print(nameText)
        
        nameText.text = s.driver.name + "\n" + s.driver.phone.getPersian()
        carText.text = s.car.model + " " + s.car.color + " - " + s.car.number.getPersian()
        
        print("endLoad")
        
        Local.save("service" , "true")
        Local.save("car" , carText.text!)
        Local.save("driver" , nameText.text!)
    }
    
    func load2(_ name:String, _ car:String)
    {
        nameText.text = name
        carText.text = car
    }

    
    
    @IBAction func onButton(_ sender: Any)
    {
        //vc.hideDriver()
        self.dismiss(animated: true, completion: nil)
    }

}
