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

class HomeView: GPS
{
    
    @IBOutlet weak var haram: UIImageView!
    @IBOutlet weak var houses: UIImageView!
    @IBOutlet weak var station: UIImageView!
    @IBOutlet weak var taxi: UIImageView!
    static var animated = false
    
    
    var w :CGFloat = 0.0
    
    @IBOutlet weak var serviceRequest: UIButton!
    
    var locationManager:CLLocationManager!
    var currentLocation:CLLocationCoordinate2D?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        /*
         let screenSize: CGRect = UIScreen.main.bounds
         w = screenSize.width
         let p = w / 375
         */
        //serviceRequest.titleLabel?.font = serviceRequest.titleLabel?.font?.withSize(15 * p)
        
        self.view.clipsToBounds = true
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        if !HomeView.animated
        {
            animateCar()
        }
        else
        {
            animateCar()
        }
    }
    
    func animateCar()
    {
        
        HomeView.animated = true
        
        let width = UIScreen.main.bounds.width

        
        func move(_ obj:UIImageView, _ p:CGFloat = 1.0)
        {
            let orginalX =  obj.frame.origin.x
            let dis :CGFloat = ((obj.frame.width - width) / 2) * p
            obj.frame.origin.x += dis
            print("dis", dis)
            
            UIView.animate(withDuration: 1.25, delay: 0.5, options: .curveEaseOut, animations: {
                
                obj.frame.origin.x = orginalX
                
            }, completion: nil)
        }
        
        move(haram, 0.2)
        move(houses, 0.4)
        move(station, 0.7)
        
        let X = taxi.frame.origin.x
        taxi.frame.origin.x -= width * 0.75
        
        UIView.animate(withDuration: 1.25, delay: 0.5, options: .curveEaseOut, animations: {
            self.taxi.frame.origin.x = X
        }, completion: nil)
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
        
        func onReceivedString(_ status:PostStatus, _ name:String?)
        {
            print("Simple Request -------> ", "location name recieved", name ?? "no name")
            
            if let name = name ,status == .Yes
            {
                print("Simple Request -------> ", "try to simple request")
                Requests.simpleRequest(name, currentLocation!, afterRequest)
            }
        }
        
        print("Simple Request -------> ", "try to get  location name")
        Requests.locationToName(coordinate: currentLocation!, oncomplete: onReceivedString)
        
    }
    
    
    
    //MARK: - On Touch Buttons
    @IBAction func serviceRequest(_ sender: Any)
    {
        print(Local.load("login"))
        if (!gps || !internet){return}
        
        print("Simple Request -------> ", "Start")
        inProgress = true
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    @IBAction func favoriteList(_ sender: Any) {
    }
    
    
    
    @IBAction func numOfServices(_ sender: Any) {
    }
    
}

