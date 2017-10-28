//
//  ViewController.swift
//  zin
//
//  Created by Morteza on 5/19/1396 AP.
//  Copyright © 1396 Pasys. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class HomeDriver: GPS
{
    
    var w :CGFloat = 0.0
    
    
    var locationManager:CLLocationManager!
    var currentLocation:CLLocationCoordinate2D?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        handler
        
        let screenSize: CGRect = UIScreen.main.bounds
        w = screenSize.width
        let p = w / 375
        
        //serviceRequest.titleLabel?.font = serviceRequest.titleLabel?.font?.withSize(15 * p)
        
        self.view.clipsToBounds = true
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        var per = p*1.5
        if per>2{per=2}
        switchBt.transform = CGAffineTransform(scaleX: per, y: per)
        print(per)
    }
    
    
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var switchBt: UISwitch!
    @IBAction func onSwitch(_ sender: Any)
    {
        inProgress = true
        
        if switchBt.isOn
        {
            image.image = UIImage(named: "driverOn")
        }
        else
        {
            image.image = UIImage(named: "driverOff")
        }
        
        func onComplete(_ status:PostStatus)
        {
            if status == .Yes
            {
                if(switchBt.isOn)
                {
                    Alert("فعال سازی با موفقیت انجام شد", "", "باشه")
                }
                else
                {
                    Alert("در وضعیت غیرفعال قرار گرفتید","","باشه")
                }
            }
            else
            {
                print(status)
                Alert("لطفا دوباره تلاش فرمایید", "فرآیند با خطا مواجه شد", "باشه")
                
                DispatchQueue.main.async {
                    self.switchBt.isOn = !self.switchBt.isOn
                }
                
                
            }
            
            handler.state = switchBt.isOn
            
        }
        
        Requests.driverActive(switchBt.isOn, onComplete)
    }
    
    
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        currentLocation = manager.location!.coordinate
        locationManager.stopUpdatingLocation()
        
        print("Simple Request -------> ", "LocationUpdated")
        
        func afterRequest(_ status:PostStatus, service:Service? = nil)
        {
            print("Simple Request -------> ", "get result from server")
            inProgress = false
            print("Simple Request -------> ", "Finish")
            
            let title:String = "درخواست سرویس"
            var msg:String
            
            switch status {
            case .Yes:
                msg = "سرویس درخواست شد"
                
                if let service = service
                {
                    print(service.ID)
                    print(service.time)
                    print(service.driver.name)
                    print(service.driver.imgPath)
                    print(service.driver.phone)
                    print(service.car.color)
                    print(service.car.model)
                    print(service.car.number)
                }
                
            case .No:
                msg = "سرویس یافت نشد"
                
            default:
                msg = "عدم پاسخ دهی مناسب از سرور"
            }
            
            Alert(msg, title, "OK")
        }
        
        func onReceivedString(_ status: PostStatus, _ name:String?)
        {
            if let name = name, status == .Yes
            {
                Requests.simpleRequest(name, currentLocation!, afterRequest)
            }
            else
            {
                Alert("Error on locationManager Update from locationToName()")
            }
        }
        
        print("Simple Request -------> ", "try to get  location name")
        Requests.locationToName(coordinate: currentLocation!, oncomplete: onReceivedString)
        
    }
    
    
    
}

