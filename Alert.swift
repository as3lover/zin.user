//
//  Alert.swift
//  zin
//
//  Created by Morteza on 6/11/1396 AP.
//  Copyright © 1396 Pasys. All rights reserved.
//

import UIKit

public enum SettingsType: String {
    
    case about = "General&path=About"
    case accessibility = "General&path=ACCESSIBILITY"
    case airplaneMode = "AIRPLANE_MODE"
    case autolock = "General&path=AUTOLOCK"
    case cellularUsage = "General&path=USAGE/CELLULAR_USAGE"
    case brightness = "Brightness"
    case bluetooth = "Bluetooth"
    case dateAndTime = "General&path=DATE_AND_TIME"
    case facetime = "FACETIME"
    case general = "General"
    case keyboard = "General&path=Keyboard"
    case castle = "CASTLE"
    case storageAndBackup = "CASTLE&path=STORAGE_AND_BACKUP"
    case international = "General&path=INTERNATIONAL"
    case locationServices = "LOCATION_SERVICES"
    case accountSettings = "ACCOUNT_SETTINGS"
    case music = "MUSIC"
    case equalizer = "MUSIC&path=EQ"
    case volumeLimit = "MUSIC&path=VolumeLimit"
    case network = "General&path=Network"
    case nikePlusIPod = "NIKE_PLUS_IPOD"
    case notes = "NOTES"
    case notificationsId = "NOTIFICATIONS_ID"
    case phone = "Phone"
    case photos = "Photos"
    case managedConfigurationList = "General&path=ManagedConfigurationList"
    case reset = "General&path=Reset"
    case ringtone = "Sounds&path=Ringtone"
    case safari = "Safari"
    case assistant = "General&path=Assistant"
    case sounds = "Sounds"
    case softwareUpdateLink = "General&path=SOFTWARE_UPDATE_LINK"
    case store = "STORE"
    case twitter = "TWITTER"
    case facebook = "FACEBOOK"
    case usage = "General&path=USAGE"
    case video = "VIDEO"
    case vpn = "General&path=Network/VPN"
    case wallpaper = "Wallpaper"
    case wifi = "WIFI"
    case tethering = "INTERNET_TETHERING"
    case blocked = "Phone&path=Blocked"
    case doNotDisturb = "DO_NOT_DISTURB"
    
}

extension UIViewController {

    //MARK: -  Alert (Normal)
    func Alert(_ message:String, _ title:String = "", _ okText:String = "Ok")
    {
        AlertShow(title: title, message: message, btn1: okText)
    }
    
    func Alert(_ message:String, _ title:String = "", _ cancelText:String = "Cancel", _ settingText:String = "Settings", _ settingType:SettingsType = .general, _ general:Bool = true)
    {
        AlertShow(title: title, message: message, btn1: cancelText, btn2: settingText, action: settingType, general)
    }

    
    //////
    func AlertShow(title:String, message:String, btn1:String, btn2:String?=nil, action:SettingsType? = nil, _ general:Bool = true)
    {
        let alertController = UIAlertController (title: title, message: message, preferredStyle: .alert)
        
        
        let cancelAction = UIAlertAction(title: btn1, style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        
        if let btn2 = btn2, let action = action
        {
            let path = "App-Prefs:root"
            
            let settingsAction = UIAlertAction(title: btn2, style: .default) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                    return
                }
                
                if(general)
                {
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(URL(string:path + "=" + action.rawValue)!, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(URL(string:path + "=" + action.rawValue)!)
                        }
                        
                    }
                }
                else
                {
                    UIApplication.shared.openURL(NSURL(string: UIApplicationOpenSettingsURLString)! as URL)
                }
            }
            
            alertController.addAction(settingsAction)
        }
        
        if self.inProgress
        {
            self.inProgress = false
        }
        
        DispatchQueue.main.async {
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        
    }
    
    
    
    //MARK: - Alert(Input)
    func AlertInput(message:String, title:String, cancel:String, save:String, placeHolder:String, fieldText:String, function:@escaping (String)->())
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: save, style: .default, handler:
            {
                alrt -> Void in
                let textField = alert.textFields![0] as UITextField
                if textField.text != ""
                {
                    function(textField.text!)
                }
                else
                {
                    function(textField.placeholder!)
                }
        }))
        
         alert.addAction(UIAlertAction(title: cancel, style: .default, handler:nil))
        
        alert.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = placeHolder
            textField.text = fieldText
            textField.textAlignment = .right
            var fontSize = textField.font?.pointSize;
            if fontSize == nil
            {
                fontSize = 10
            }
            textField.font = UIFont(name: "Sahel", size: fontSize!)
        })
        
        DispatchQueue.main.async {
            if self.inProgress
            {
                self.inProgress = false
            }
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }


}
