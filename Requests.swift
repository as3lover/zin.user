//
//  Requests.swift
//  mapTest
//
//  Created by Morteza on 6/6/1396 AP.
//  Copyright © 1396 Pasys. All rights reserved.
//

import UIKit
import MapKit

class Requests:NSObject {
    
    //MARK: -API Keys
    //static let PlaceKey = "AIzaSyCV_OX9qUjd0gsa8ZqM9GsQ5rUXbF5b6bA"
    //static let PlaceKey = "AIzaSyDDjoOMPLcf1L5XMsYtoLCIPkix9Y770PA"//project 10
    //static let PlaceKey = "AIzaSyAzOUKo1mKlrgTTeBFl2CwFWeNeiKGZo64"//project 11
    static let PlaceKey = "AIzaSyCwItnoxkScxwaIKeHemySZz64F29I2dYM"//project 12
    static let DistanceMatrixKey = "AIzaSyBLhLBjH-PH_KkKT4x9Cd26eYgQmqsSFjE"//project 12
    static let GeoKey = "AIzaSyCrCiN7M8YambsyJNWl7Z4AwoJ-NH58Dv4"
    //static let GeoKey = "AIzaSyB-F9EAKxWNlivyGagBQJIVB8Y24qP5qXw" //Bozorgvar

    
    static var last:String?
    static var last2:[String:Any]?
    
    
    //MARK: - coordinate to place String
    static func locationToName(coordinate:CLLocationCoordinate2D, oncomplete:@escaping (PostStatus, String?)->())
    {
        let lat = String(coordinate.latitude)
        let long = String(coordinate.longitude)
        
        //Google API
        let urlString = "https://maps.googleapis.com/maps/api/geocode/json?latlng=" + lat + "," + long + "&language=" + lang + "&key=" + GeoKey
        
        //Google Answer
        func complete(_ list1:Any)
        {
            if list1 is PostStatus
            {
                oncomplete(list1 as! PostStatus, nil)
                return
            }
            var list:[String:Any]
            if let list1 = list1 as? [String:Any]
            {
                list = list1
            }
            else
            {
                oncomplete(.InternlError, nil)
                return
            }
            
            var address = ""
            var locality = ""
            var route = ""
            
            //taking address from json
            if let status = list["status"] as? String, status == "OK"
            {
                if let results = list["results"] as? [[String : AnyObject]]
                {
                    if results.count > 0
                    {
                        let item = results[0]
                        
                        if let addressComponents = item["address_components"] as? [[String : AnyObject]]
                        {
                            let filteredItems1 = addressComponents.filter{ if let types = $0["types"] as? [String] {
                                return types.contains("locality") } else { return false } }
                            
                            let filteredItems2 = addressComponents.filter{ if let types = $0["types"] as? [String] {
                                return types.contains("route") } else { return false } }
                            
                            
                            if !filteredItems1.isEmpty {
                                locality = filteredItems1[0]["long_name"] as! String
                                if locality == "Mashhad"
                                {
                                    locality = "مشهد"
                                }
                            }
                            
                            if !filteredItems2.isEmpty {
                                route = filteredItems2[0]["long_name"] as! String
                            }
                            
                            address = locality
                            if address != "" && route != ""
                            {
                                address += "، " + route
                            }
                            
                        }
                    }
                }
            }
            
            if address == "" || address == "Unnamed Road"
            {
                address = "مکان بی نام"
            }
            
            oncomplete(.Yes, address)
        }
        
        post(urlString, complete)
    }
    
    //MARK: - Save FAV Location
    static func saveLocation(_ address:String, _ label:String, _ loc:CLLocationCoordinate2D, _ onComplete:@escaping (PostStatus)->())
    {
        var url = "http://zintransport.ir/api/"
        var data:String = "Section=SaveFavLocation"
        if let mobile = Local.mobile, let token = Local.token
        {
            let lat = String(loc.latitude)
            let long = String(loc.longitude)
            
            data += "&lat=" + lat + "&long=" + long
            data += "&mobile=" + mobile + "&token=" + token
            data += "&address=" + address + "&label=" + label
        }
        else
        {
            return
        }
        
        
        func complete(_ list:Any)
        {
            let(status, data) = zinData(list)
            if data != nil{}
            
            onComplete(status)

            
        }

        post(url, complete, data)
        
    }
    
    
    //MARK: - Simple Request
    static func simpleRequest(_ address:String, _ loc:CLLocationCoordinate2D, _ onComplete:@escaping (PostStatus, Service?)->())
    {
        var url = "http://zintransport.ir/api/"
        var data:String = "Section=SimpleServiceRequest"
        if let mobile = Local.mobile, let token = Local.token
        {
            let lat = String(loc.latitude)
            let long = String(loc.longitude)
            
            data += "&lat=" + lat + "&long=" + long
            data += "&mobile=" + mobile + "&token=" + token
            data += "&address=" + address
        }
        else
        {
            return
        }
        
        //on recive data
        func complete(_ list:Any)
        {
            let(status, data) = zinData(list)
            
            if status == .Yes
            {
                if let inf = data?["carinfo"] as? [String:String],
                    let time = data?["estimatereceivetime"] as? String,
                    let ID = data?["serviceid"] as? String
                {
                    if let phone = inf["driverid"],
                        let number = inf["carno"],
                        let model = inf["carmodel"],
                        let color = inf["carcolor"],
                        let name = inf["drivername"],
                        let imgPath = inf["photo"]
                    {
                        let car = Car(number: number, model: model, color: color)
                        let driver = Driver(phone: phone, name: name, imgPath: imgPath)
                        let service = Service(car: car, driver: driver, time: time, ID: ID)
                        
                        onComplete(status, service)
                        return
                    }
                }
            }
            else
            {
                onComplete(status, nil)
                return
            }
            
            onComplete(.ServerError, nil)
            return
        }
        
        post(url, complete, data)
        
    }

    
    //MARK: - Map Request
    static func mapRequest(_ address1:String, _ address2:String, _ loc1:CLLocationCoordinate2D, _ loc2:CLLocationCoordinate2D, _ onComplete:@escaping (PostStatus, Service?)->())
    {
        var url = "http://zintransport.ir/api/"
        var data:String = "Section=MapServiceRequest"
        if let mobile = Local.mobile, let token = Local.token
        {
            let slat = String(loc1.latitude)
            let slong = String(loc1.longitude)
            let elat = String(loc2.latitude)
            let elong = String(loc2.longitude)
            
            data += "&slat=" + slat + "&slong=" + slong
            data += "&elat=" + elat + "&elong=" + elong
            data += "&mobile=" + mobile + "&token=" + token
            data += "&saddress=" + address1
            data += "&eaddress=" + address2
        }
        else
        {
            return
        }
        
        //on recive data
        func complete(_ list:Any)
        {
            let(status, data) = zinData(list)
            
            if status == .Yes
            {
                if let inf = data?["carinfo"] as? [String:String],
                    let time = data?["estimatereceivetime"] as? String,
                    let ID = data?["serviceid"] as? String
                {
                    if let phone = inf["driverid"],
                        let number = inf["carno"],
                        let model = inf["carmodel"],
                        let color = inf["carcolor"],
                        let name = inf["drivername"],
                        let imgPath = inf["photo"]
                    {
                        let car = Car(number: number, model: model, color: color)
                        let driver = Driver(phone: phone, name: name, imgPath: imgPath)
                        let service = Service(car: car, driver: driver, time: time, ID: ID)
                        
                        onComplete(status, service)
                        return
                    }
                }
            }
            else
            {
                onComplete(status, nil)
                return
            }
            
            onComplete(.ServerError, nil)
            return
        }
        
        post(url, complete, data)
        
    }

    
    
    
    //MARK: - positionList
    static func positionList(_ coordinate:CLLocationCoordinate2D, _ onComplete:@escaping ([Agancy],[CarPos])->())
    {
       var url = "http://zintransport.ir/api/"
        var data:String = "Section=PositionList"
        if let mobile = Local.mobile, let token = Local.token
        {
            let lat = String(coordinate.latitude)
            let long = String(coordinate.longitude)
            
            data += "&lat=" + lat + "&long=" + long
            data += "&mobile=" + mobile + "&token=" + token
            
        }
        else
        {
            return
        }
        
        var agancies = [Agancy]()
        var cars = [CarPos]()
        
        func complete(_ list:Any)
        {
            let(_, data) = zinData(list)
            if let data = data as? [String:[[String:Any]]]{

                if let agancy = data["agancy"]
                {
                    for item in agancy
                    {
                        var agancy = Agancy()
                        if let lat = item["lat"] as? String, let long = item["long"] as? String
                        {
                            if let lat = Double(lat), let long = Double(long)
                            {
                                agancy.lat = lat
                                agancy.long = long
                                agancy.address = item["location"] as? String
                                agancy.name = item["name"] as? String
                                agancy.phone = item["phone"] as? String
                                agancy.manager = item["manager"] as? String
                                
                                agancies.append(agancy)
                            }
                        }
                    }
                }
                
                if let list = data["car"]
                {
                    for item in list
                    {
                        var car = CarPos()
                        if let lat = item["lat"] as? String, let long = item["long"] as? String
                        {
                            if let lat = Double(lat), let long = Double(long)
                            {
                                car.lat = lat
                                car.long = long
                                cars.append(car)
                            }
                        }
                    }
                }
                
                
                onComplete(agancies, cars)
            }
        }
       
        post(url, complete, data)
    }
    
    
    
    
    static func zinData(_ data:Any)-> (status:PostStatus, data:[String:Any]?)
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
                            return(.Yes, data as? [String:Any])
                        }
                        else{return(.ServerError, nil)}
                    }
                    else{return(.No, nil)}
                }
                else{return(.ServerError, nil)}
            }
            else{return(.ServerError, nil)}
        }
        else{return(.NoServer, nil)}
    }
    
    
    
    //MARK: - AutoComplete
    static func stringToList(str:String?, onComplete:@escaping (PostStatus, [String:String]?)->())
    {
        var string: String! = "مشهد"
        if str != nil && str != ""
        {
            string = str
        }
        
        string = string.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        //print("stringToList:", string)
        let urlString = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=" + string + "&types=geocode&language=" + lang + "&key=" + PlaceKey
        
        
        //Google Answer
        func complete(_ list1:Any)
        {
            ///////////////
            if list1 is PostStatus
            {
                onComplete(list1 as! PostStatus, nil)
                return
            }
            var list:[String:Any]
            if let list1 = list1 as? [String:Any]
            {
                list = list1
            }
            else
            {
                onComplete(.InternlError, nil)
                return
            }
            ///////////
            
            var items = [String:String]()
            
            //taking list from json
            if let status = list["status"] as? String, status == "OK"
            {
                if let predictions = list["predictions"] as? [[String : AnyObject]]
                {
                    for item in predictions
                    {
                        if let des = item["description"] as? String, let placeID = item["place_id"] as? String
                        {
                            //print(des, placeID)
                            //idToLocation(placeID, nil)
                            items[placeID] = des
                        }
                    }
                }
            }
            
            onComplete(.Yes, items)
            
        }
        
        
        
        post(urlString, complete)
    }
    
    
    
    
    
    
    //MARK: - Place Id to Location
    static func idToLocation(_ placeID: String, _ onComplete:@escaping ((PostStatus, CLLocationCoordinate2D?)->()))
    {
        let urlString = "https://maps.googleapis.com/maps/api/place/details/json?placeid=" + placeID + "&key=" + PlaceKey
        
        func complete(_ list1:Any)
        {
            ///////////////
            if list1 is PostStatus
            {
                onComplete(list1 as! PostStatus, nil)
                return
            }
            var list:[String:Any]
            if let list1 = list1 as? [String:Any]
            {
                list = list1
            }
            else
            {
                onComplete(.InternlError, nil)
                return
            }
            ///////////
            
            if let status = list["status"] as? String, status == "OK"
            {
                if let result = list["result"] as? [String : AnyObject]
                {
                    if let latlng = result["geometry"]?["location"] as? [String : AnyObject]
                    {
                        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latlng["lat"] as! CLLocationDegrees, longitude: latlng["lng"] as! CLLocationDegrees)
                        
                        onComplete(.Yes, coordinate)
                    }
                }
            }
        }
        //print(urlString)
        post(urlString, complete)
    }
    
    
    //MARK: - Driver Activate
    static func driverActive(_ active:Bool, _ onComplete:@escaping (PostStatus)->())
    {
        var url = "http://zintransport.ir/api/"
        var data = "Section=SetDriverActivate"

        
        if let mobile = Local.mobile, let token = Local.token
        {
            data += "&mobile=" + mobile + "&token=" + token
            
            var activate = "0"
            if active
            {
                activate = "1"
            }
            
            data += "&active=" + activate
            
        }
        else
        {
            onComplete(.InternlError)
            return
        }
        
        
        func complete(_ list:Any)
        {
            let(status, _) = zinData(list)
            onComplete(status)
        }
        
        post(url, complete, data)
    }
    
    //MARK: - Login
    static func login(_ user:String?, _ pass:String?, _ onComplete: @escaping ((PostStatus)->()), _ driver:Bool = false)
    {
        var _user:String! = ""
        var _pass:String! = ""
        
        if user != nil{
            _user = user
        }
        
        if pass != nil{
            _pass = pass
        }
        
        var section:String
        if driver
        {
            section = "DriverSignIn"
        }
        else
        {
            section = "SignIn"
        }
        
        var url = "http://zintransport.ir/api/"
        var data = "Section=" + section + "&mobile=" + _user + "&password=" + _pass

        
        func complete(_ list:Any)
        {
            if(list is PostStatus)
            {
                onComplete(list as! PostStatus)
                return
            }
            
            print(list)
            //cast json
            if let list = list as? [String:Any]
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
                            if let data = list["data"] as? [String:Any]
                            {
                                if let token = data["token"] as? String
                                {
                                    print("token", token)
                                    Local.save("token", token)
                                    Local.save("mobile", _user)
                                    onComplete(.Yes)
                                }
                                else{onComplete(.ServerError)}
                            }
                            else{onComplete(.ServerError)}
                        }
                        else{onComplete(.No)}
                    }
                    else{onComplete(.ServerError)}
                }
                else{onComplete(.ServerError)}
            }
            else{onComplete(.NoServer)}
            /*
            //Server Status
            if let status = (list as? [String:Any])?["status"] as? String , status == "200"
            {
                //Server OK
                if let
                
            }
 */
        }
        
        post(url , complete, data)
    }
    
    //MARK: - POST
    static func post(_ urlString:String, _ onComplete:@escaping ((Any)->()), _ data:String? = nil)
    {
        print("post", data ?? "")
        last = urlString
        let url:URL? = URL(string: urlString)
        
        if url == nil{return}
        
        var req = URLRequest(url:url!)
        req.httpMethod = "POST"
        
        if let data = data{
            req.httpBody = data.data(using: .utf8)
        }
        
        
        
        URLSession.shared.dataTask(with:req) { (data, response, error) in
            
            if let error = error {
                print("error 1: ", error)

                onComplete(PostStatus.NoInternet)
            }
            else
            {
                do {
                    
                    let parsedData = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                    onComplete(parsedData)
                }
                catch let error as NSError
                {
                    print("error 2: ", error)

                    do {
                        
                        let parsedData = try JSONSerialization.jsonObject(with: data!)
                        print(parsedData)
                    }
                    catch let error as NSError
                    {
                        print("EERR", error)
                    }
                    
                    
                    let dd = String(data: data!, encoding: String.Encoding.utf8) as String!
                    
                    print(dd ?? "!!!!!!")
                    
                    onComplete(PostStatus.InternlError)
                }
            }
            
            }.resume()
    }
    
    
    ///////
    
    
}
