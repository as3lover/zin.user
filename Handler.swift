//
//  Handler.swift
//  zin
//
//  Created by Morteza on 6/15/1396 AP.
//  Copyright © 1396 Pasys. All rights reserved.
//

import Foundation
import MapKit

class send:DriverRequests{}

class Handler:NSObject, CLLocationManagerDelegate
{
    
    var locationManager:CLLocationManager!
    var currentLocation:CLLocationCoordinate2D?
    private static var instnce:Handler?
    private var active:Bool = false
    private var timer:Timer2!
    
    
    static var instance:Handler!
    {
        print("start Handler")
        if let ins = instnce
        {
            return ins
        }
        else
        {
            instnce = Handler()
            return instnce!
        }
    }

    override init()
    {
        super.init()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        timer = Timer2(step: 2, function: turnOn, repeats: true, start: false)
        
        var t = Timer.scheduledTimer(timeInterval: 1, target: self, selector: "ppp", userInfo: nil, repeats: true)
    }
    
    func ppp()
    {
        if active
        {
            sendLocation()
        }
    }
    
    var state:Bool
    {
        set(val)
        {
            active = val
            print("State " , val)
            
            if(active)
            {
                timer.start()
                sendLocation()
                turnOn()
                
            }
            else
            {
                timer.stop()
                turnOff()
            }
        }
        
        get
        {
            return active
        }
    }
    
    func turnOn()
    {
        print("turnOn")
        locationManager.startUpdatingLocation()
    }
    
    func turnOff()
    {
        locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        currentLocation = manager.location!.coordinate
        
        if active
        {
            sendLocation()
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    func sendLocation()
    {
        if currentLocation != nil
        {
            print(Date().timeIntervalSince1970)
            send.SetDriverLocation(currentLocation!)
        }
    }
    
}

extension NSObject
{
    var handler:Handler
    {
        return Handler.instance
    }
}
