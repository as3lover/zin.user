//
//  DriverRequests.swift
//  zin
//
//  Created by Morteza on 6/15/1396 AP.
//  Copyright © 1396 Pasys. All rights reserved.
//

import Foundation
import CoreLocation

class DriverRequests
{
    private static var post = Requests.post
    private static var zinData = Requests.zinData
    
    static var lang:String
    {
        return NSObject.lang
    }
    
    
    private static var url:String = "http://zintransport.ir/api/"
    
    private static var mobile:String?{
        return Local.mobile
    }
    
    private static var token:String?{
        return Local.token
    }
    
    private static var saved:Bool{
        return mobile != nil && token != nil
    }
    
    private static func section (_ sec:Section)-> String
    {
        return String("Section=" + sec.rawValue)
    }
    
    private static func latLong(_ loc:CLLocationCoordinate2D)->String
    {
        return String("lat=" + String(loc.latitude) + "&long=" + String(loc.longitude))
    }
    
    private static var mobileToken:String
    {
        if(saved)
        {
            return("mobile=" + mobile! + "&token=" + token!)
        }
        else
        {
            return ""
        }
    }

    
    static private func getData(_ list:[String:String])->String
    {
     
        var str:String = ""

        
        for (key, val) in list
        {
            if str != ""
            {
                str += "&"
            }
            
            str += key + "=" + val
        }
        
        return str
    }
    
    //MARK: - Functions
    
    static func SetDriverLocation(_ loc:CLLocationCoordinate2D)
    {
        if !saved{return}
        
        func comp(_ list:Any)
        {
            let (status, _) = zinData(list)
            
            if status == .Yes
            {
                print("Location Set OK")
            }
            
        }
        
        let data = section(.SetDriverLocation) + "&" + latLong(loc) + "&" + mobileToken
        post(url, comp, data)
    }
    
    static func getProfileAvatar(onComplete:@escaping ((PostStatus, ProfileAvatar?)->()), driver:Bool)
    {
        if !saved{return}
        
        func comp(_ list:Any)
        {
            let (_, data) = zinData(list)
            
            var avatar = ProfileAvatar()
            
            if let data = data
            {
                print(data)
                
                avatar.image = data["img"] as? String
                avatar.fullName = data["Fullname"] as? String
                avatar.mobile = data["mobile"] as? String
                
                onComplete(.Yes, avatar)
                return
            }
            
            onComplete(.ServerError, nil)
            return
        }
        
        var data:String!
        
        if driver
        {
            data = section(.DriverProfileAvatar)
        }
        else
        {
            data = section(.ProfileAvatar)
        }
        
        
        data = data + "&" + mobileToken + "&lang=" + lang
        post(url, comp, data)
    }
    
    static func MessageList(onComplete:@escaping ((PostStatus, [Message]?)->()), driver:Bool)
    {
        if !saved{return}
        
        func comp(_ list:Any)
        {
            let (_, data) = zinData(list)
            
            var messages = [Message]()
            if let data = data?["msg"] as? [[String:String]]
            {
                
                for data in data
                {
                    var message = Message()
                    
                    message.date = data["date"]
                    message.text = data["text"]
                    message.title = data["caption"]
                    
                    messages.append(message)
                }
                
                messages = messages.reversed()
                onComplete(.Yes, messages)
                return
            }
            
            onComplete(.ServerError, nil)
            return
        }
        
        var data:String!
        
        if driver
        {
            data = section(.DriverMessageList)
        }
        else
        {
            data = section(.MessageList)
        }
        
        data = data + "&" + mobileToken
        post(url, comp, data)
    }
    
    static func DriverSentMsg(_ onComplete:@escaping (PostStatus, [Message]?)->())
    {
        if !saved{return}
        
        func comp(_ list:Any)
        {
            let (_, data) = zinData2(list)
            
            var messages = [Message]()
            if let data = data
            {
                
                for data in data
                {
                    var message = Message()
                    
                    message.date = data["date"]
                    message.text = data["text"]
                    message.title = data["caption"]
                    
                    messages.append(message)
                }
                
                messages = messages.reversed()
                onComplete(.Yes, messages)
                return
            }
            
            onComplete(.ServerError, nil)
            return
        }
        
        let data = section(.DriverSentMsg) + "&" + mobileToken
        post(url, comp, data)
    }
    
    private static func zinData2(_ data:Any)-> (status:PostStatus, data:[[String:String]]?)
    {
        if(data is PostStatus)
        {
            return (data as! PostStatus, nil)
        }
        
        //print(data)
        //cast json
        if let list = data as? [String:Any]
        {
            //server status
            if let status = list["status"] as? Int, status == 200
            {
                //catch status
                if let result = list["result"] as? Int
                {
                    //result status
                    if result == 1
                    {
                        //catch data
                        if let data = list["data"]
                        {
                            return(.Yes, data as? [[String:String]])
                        }
                        else{return(.Yes, [[String:String]]())}
                    }
                    else{return(.Yes, [[String:String]]())}
                }
                else{return(.ServerError, nil)}
            }
            else{return(.ServerError, nil)}
        }
        else{return(.NoServer, nil)}
    }
    
    private static func zinData3(_ data:Any)-> (status:PostStatus, data:[String:Any]?)
    {
        if(data is PostStatus)
        {
            return (data as! PostStatus, nil)
        }
        
        //cast json
        if let list = data as? [String:Any]
        {
            //server status
            if let status = list["status"] as? Int, status == 200
            {
                //catch status
                if let result = list["result"] as? Int
                {
                    //result status
                    if result == 1
                    {
                        //catch data
                        if let data = list["data"]
                        {
                            return(.Yes, data as? [String:Any])
                        }
                        else{return(.Yes, [String:Any]())}
                    }
                    else{return(.Yes, [String:Any]())}
                }
                else{return(.ServerError, nil)}
            }
            else{return(.ServerError, nil)}
        }
        else{return(.NoServer, nil)}
    }
    
    static func TripInfo(onComplete:@escaping ((PostStatus, [Trip]?)->()))
    {
        if !saved{return}
        
        func comp(_ list:Any)
        {
            let (_, data) = zinData(list)
            
            var trips = [Trip]()
            if let data = data?["trip"] as? [[String:String]]
            {
                
                for data in data
                {
                    var trip = Trip()
                    
                    trip.date = data["date"]
                    trip.from = data["from"]
                    trip.to = data["to"]
                    trip.cost = data["cost"]
                    
                    trips.append(trip)
                }
                
                onComplete(.Yes, trips)
                return
            }
            
            onComplete(.ServerError, nil)
            return
        }
        
        let data = section(.TripInfo) + "&" + mobileToken
        post(url, comp, data)
    }
    
    static func EditProfile(_ profile:ProfileInfo, onComplete:@escaping (PostStatus)->())
    {
        if !saved{return}
        
        func comp(_ list:Any)
        {
            let (status, _) = zinData(list)
            onComplete(status)
            return
        }
        
        var dataList = [String:String]()
        
        dataList["fname"] = profile.firstName ?? ""
        dataList["lname"] = profile.lastName ?? ""
        dataList["gender"] = profile.gender ?? ""
        dataList["dob"] = profile.dob ?? ""
        dataList["email"] = profile.email ?? ""
        dataList["tel"] = profile.tel ?? ""
        
        
        let data = section(.EditProfile) + "&" + mobileToken + "&" + getData(dataList)
        post(url, comp, data)
    }
    
    static func DriverSendMsg(subject:String, text:String, onComplete:@escaping (PostStatus)->())
    {
        if !saved{return}
        
        func comp(_ list:Any)
        {
            let (status, _) = zinData2(list)
            onComplete(status)
            return
        }
        
        var dataList = [String:String]()
        
        dataList["subject"] = subject
        dataList["text"] = text
        
        
        let data = section(.DriverSendMsg) + "&" + mobileToken + "&" + getData(dataList)
        post(url, comp, data)
    }

    static func DriverDoneServices(date:String, onComplete:@escaping ((PostStatus, [Trip]?)->()))
    {
        if !saved{return}
        
        func comp(_ list:Any)
        {
            let (_, data) = zinData(list)
            
            var trips = [Trip]()
            if let data = data?["info"] as? [[String:String]]
            {
                
                for data in data
                {
                    var trip = Trip()
                    
                    trip.date = data["time"]
                    trip.from = data["start"]
                    trip.to = data["end"]
                    trip.cost = data["cost"]
                    trip.type = data["type"]
                    
                    trips.append(trip)
                }
                
                onComplete(.Yes, trips)
                return
            }
            
            onComplete(.ServerError, nil)
            return
        }
        
        let data = section(.DriverDoneServices) + "&" + mobileToken + "&date=" + date
        post(url, comp, data)
    }
    
    
    static func getFavoriteLocation(onComplete:@escaping ((PostStatus, [FavLoc]?)->()))
    {
        if !saved{return}
        
        func comp(_ list:Any)
        {
            let (status, data) = zinData3(list)
            
            if status != .Yes
            {
                onComplete(status, nil)
                return
            }

            var locs = [FavLoc]()
            
            if let data = data//?["location"] as? [[String:String]]
            {
                
              
                
            }
            else
            {
                print("error 1")
            }
            /*
            if let locations = data?["location"] as? [[String:String]]
            {
                
                
                for data in locations
                {
                    let lat:String! = data["lat"] ?? ""
                    let long:String! = data["long"] ?? ""
                    let label:String! = data["label"] ?? ""
                    let address:String! = data["address"] ?? ""
                    
                    
                    let loc = FavLoc(lat: lat, long: long, label: label, address: address)
                    locs.append(loc)
                }
                
            }
            */
 
            onComplete(.Yes, locs)
            return
        }
 
        let data = section(.FavoriteLocation) + "&" + mobileToken
        post(url, comp, data)
    }


        
    static func DriverProfileInfo(onComplete:@escaping (PostStatus, ProfileInfo?)->())
    {
        if !saved{return}
        
        func comp(_ list:Any)
        {
            let (_, data) = zinData(list)
            
            var profile = ProfileInfo()
            
            if let data = data
            {
                print(data)
                
                profile.image = data["img"] as? String
                profile.email = data["email"] as? String
                profile.firstName = data["fname"] as? String
                profile.lastName = data["lname"] as? String
                profile.gender = data["gender"] as? String
                profile.tel = data["tel"] as? String
                profile.mobile = data["mobile"] as? String
                profile.dob = data["dob"] as? String
                
                onComplete(.Yes, profile)
                return
            }
           
            onComplete(.ServerError, nil)
            return
        }
        
        var _section:String!
        
        if Constants.Driver
        {
            _section = section(.DriverProfileInfo)
        }
        else
        {
            _section = section(.ProfileInfo)
        }
        
        let data = _section + "&" + mobileToken
        post(url, comp, data)
    }
    
    
    static func DriverSignIn(_ user:String, _ pass:String, _ onComplete:@escaping (PostStatus)->())
    {
        if !saved{return}
        
        func comp(_ list:Any)
        {
            let (status, _) = zinData(list)
            
            onComplete(status)
            
        }
        
        let data = section(.DriverSignIn) + "&mobile=" + user + "&password=" + pass
        
        post(url, comp, data)
    }
    
    
    static func GCMToken()
    {
        print("sending")
        
        if !saved{return}
        if Constants.GCMtoken == nil {return}
        
        func comp(_ list:Any)
        {
            print(list)
            let (status, _) = zinData(list)
            
            print("Send GCM Token >>>>>>>>>>>>>>>>>>" , status.rawValue)
            
            if status == .Yes
            {
                Constants.GCMRegistered = true
            }
            else
            {
                 Constants.GCMRegistered = false
            }
            
        }
        
        var sec = Section.SendGCMToken
        if Constants.Driver{
            sec = Section.DriverSendGCMToken
        }
        
        var data:String! = section(sec) + "&mobile=" + mobile! + "&token="
        data = data + token! + "&gcmtoken=" + Constants.GCMtoken!

        post(url, comp, data)
    }
    
    

}



enum Section:String
{
    case SetDriverLocation 
    case SetDriverActivate
    case DriverSendGCMToken
    case DriverSignIn
    case DriverProfileInfo
    case DriverProfileAvatar
    case `case`
    case DriverMessageList
    case DriverSendMsg
    case DriverSentMsg
    case DriverDoneServices
    case ServiceReadyNotify
    case ServiceStart
    case ServiceEnd
    
    case ProfileInfo
    case ProfileAvatar
    case EditProfile
    case MessageList
    case TripInfo
    case FavoriteLocation
    case SendGCMToken
}
