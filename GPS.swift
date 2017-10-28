//
//  GPS.swift
//  zin
//
//  Created by Morteza on 6/11/1396 AP.
//  Copyright © 1396 Pasys. All rights reserved.
//

import Foundation
import MapKit

class GPS:UIViewController, CLLocationManagerDelegate
{
    var gps:Bool
    {
        let title = Lang.Get(.enabl_location_title) ?? "فعال سازی موقعیت"
        var message:String!
        if CLLocationManager.locationServicesEnabled()
        {
            switch(CLLocationManager.authorizationStatus())
            {
            case .notDetermined, .restricted, .denied:
                
                message = Lang.Get(.enable_location_desc)//"این برنامه اجازه دسترسی به سیستم مکان یابی را ندارد"
                Alert(message, title, Lang.Get(.cancel), Lang.Get(.setting), SettingsType.locationServices, false)
                return false
                
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            }
        }
        else
        {
            let message = Lang.Get(.enable_location_desc) ?? ""
            Alert(message, title, Lang.Get(.cancel), Lang.Get(.setting), SettingsType.locationServices)
            return false
        }
    }
}
