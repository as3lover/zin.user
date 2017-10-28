//
//  extensions.swift
//  zin
//
//  Created by Morteza on 5/25/1396 AP.
//  Copyright © 1396 Pasys. All rights reserved.
//

import UIKit

extension UIViewController{
    
    func getChildByType<T>(parent:UIView, type: T.Type)->[T]
    {
        
        func getSubviewsOfView(v:UIView) -> [T]
        {
            var list = [T]()
            
            for subview in v.subviews
            {
                list += getSubviewsOfView(v: subview)
                
                if subview is T
                {
                    list.append(subview as! T)
                }
            }
            
            return list
        }
        
        let list = getSubviewsOfView(v: parent)
        return list
    }

}


extension UIViewController
{
    func setDelegates<T>(type: T.Type)
    {
        let list = getChildByType(parent: self.view, type: T.self)
    
        
        for obj in list
        {
            if let obj = obj as? UITextField{
                obj.delegate = (self as! UITextFieldDelegate)
            }
            else if let obj = obj as? UITableView{
                obj.delegate = (self as! UITableViewDelegate)
            }
        }

    }
    
    func setTextFieldsDelegate()
    {
        let list = getChildByType(parent: self.view, type: UITextField.self)
        for obj in list
        {
            obj.delegate = (self as! UITextFieldDelegate)
        }
    }
}




extension NSObject {
    
    // Save Name of Object with this method
    func className() -> String {
        
        return NSStringFromClass(self.classForCoder)
        
    }
    
    // Convert String to object Type
    class func objectFromString(string: String) -> AnyObject? {
        return NSClassFromString(string)
    }
    
}

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}


///// ActivityIndicator


fileprivate var ActivityIndicatorViewAssociativeKey = "ActivityIndicatorViewAssociativeKey"
public extension UIView {
    var activityIndicatorView: UIActivityIndicatorView {
        get {
            if let activityIndicatorView = getAssociatedObject(&ActivityIndicatorViewAssociativeKey) as? UIActivityIndicatorView {
                return activityIndicatorView
            } else {
                let activityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
                activityIndicatorView.activityIndicatorViewStyle = .whiteLarge
                activityIndicatorView.color = UIColor.white
                activityIndicatorView.center = center
                activityIndicatorView.hidesWhenStopped = false
                
                let back = UIView()
                back.bounds = self.bounds
                back.frame = self.frame
                back.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
                addSubview(back)
                back.addSubview(activityIndicatorView)
                
                setAssociatedObject(activityIndicatorView, associativeKey: &ActivityIndicatorViewAssociativeKey, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return activityIndicatorView
            }
        }
        
        set {
            addSubview(newValue.superview!)
            setAssociatedObject(newValue, associativeKey:&ActivityIndicatorViewAssociativeKey, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

public extension NSObject {
    func setAssociatedObject(_ value: AnyObject?, associativeKey: UnsafeRawPointer, policy: objc_AssociationPolicy) {
        if let valueAsAnyObject = value {
            objc_setAssociatedObject(self, associativeKey, valueAsAnyObject, policy)
        }
    }
    
    func getAssociatedObject(_ associativeKey: UnsafeRawPointer) -> Any? {
        guard let valueAsType = objc_getAssociatedObject(self, associativeKey) else {
            return nil
        }
        return valueAsType
    }
}

extension UIViewController{
    
    var inProgress:Bool
    {
        set(value)
        {
            print(self, value)
            if value
            {
                view.activityIndicatorView.superview!.isHidden = false
                view.activityIndicatorView.startAnimating()
                self.view.bringSubview(toFront: view.activityIndicatorView.superview!)

            }
            else
            {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.view.activityIndicatorView.stopAnimating()
                    self.view.activityIndicatorView.superview!.isHidden = true
                }

            }
        }
        
        get{
            if let back = self.view.activityIndicatorView.superview, !back.isHidden
            {
                return true
            }
            else
            {
                return false
            }
        }
    }

}




extension NSObject
{
    static var topView:UIViewController?
    {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }
    
    
    static func noNet()
    {
        if let topView = UIViewController.topView
        {
            if topView.Connected
            {
                topView.Alert("دسترسی به سرور مقدور نیست، لطفا اتصال اینترنت خود را بررسی کنید.","Internet")
            }
            else
            {
                topView.Alert("WiFi", "Internet", "Cancel", "Settings", SettingsType.wifi)
            }
        }
        
    }
}


/////////////

public enum PostStatus:String{
    case NoInternet
    case NoServer
    case ServerError
    case No
    case Yes
    case InternlError
}

/////////////

struct Agancy{
    var lat:Double?
    var long:Double?
    var name:String?
    var phone:String?
    var address:String?
    var manager:String?

}

struct CarPos{
    var lat:Double?
    var long:Double?
    var direction:Int?
}

struct Car{
    var number:String
    var model:String
    var color:String
    
    init (number:String, model:String, color:String)
    {
        self.number = number
        self.color = color
        self.model = model
    }
}

class Driver{
    
    var phone:String
    var name:String
    var imgPath:String
    
    init (phone:String, name:String, imgPath:String)
    {
        self.phone = phone
        self.name = name
        self.imgPath = imgPath
    }
}

class FavLoc{
    
    var lat:String
    var long:String
    var label:String
    var address:String
    
    init (lat:String, long:String, label:String, address:String)
    {
        self.lat = lat
        self.long = long
        self.label = label
        self.address = address
    }
}


struct Service
{
    var car:Car
    var driver:Driver
    var time:String
    var ID:String
    
    init (car:Car, driver:Driver, time:String, ID:String)
    {
        self.car = car
        self.driver = driver
        self.time = time
        self.ID = ID
    }
}

struct ProfileInfo {
    var image:String?
    var email:String?
    var firstName:String?
    var lastName:String?
    var dob:String?
    var gender:String?
    var tel:String?
    var mobile:String?
}

struct ProfileAvatar {
    var image:String?
    var fullName:String?
    var mobile:String?{
        set(val){
            _mobile = val
        }
        get{
            return _mobile?.getPersian()
        }
    }
    
    private var _mobile:String?
}

struct Message {
    private var _date:String?
    var title:String?
    var text:String?
    var date:String?
    {
        get{
            if _date == nil
            {
                return ""
            }
            
            switch Constants.language
            {
            case .Persian, .Arabic:
                return self._date?.getPersian()
            default:
                return self._date
            }
        }
        
        set(val){
            _date = val
            _date = _date?.replacingOccurrences(of: "-", with: "/")
        }
    }
}

struct Trip {
    private var _date:String! = ""
    private var _cost:String! = ""
    
    var from:String?
    var to:String?
    var type:String?
    
    var date:String!
    {
        get{
            switch Constants.language{
            case .Persian, .Arabic:
                return self._date.getPersian()
            default:
                return self._date
            }
        }
        
        set(val){
            _date = val
        }
    }
    
    var cost:String!
    {
        get{
            switch Constants.language{
            case .Persian, .Arabic:
                return self._cost.getPersian()
            default:
                return self._cost
            }
        }
        
        set(val){
            _cost = val
        }
    }
}


protocol PropertyReflectable { }

extension PropertyReflectable {
    subscript(key: String) -> Any? {
        let m = Mirror(reflecting: self)
        for child in m.children {
            if child.label == key { return child.value }
        }
        return nil
    }
}


//extension Agancy : PropertyReflectable {}

///////////
extension String{
    
    mutating func toPersian()
    {
        let numbersDictionary : Dictionary = ["0" : "۰","1" : "۱", "2" : "۲", "3" : "۳", "4" : "۴", "5" : "۵", "6" : "۶", "7" : "۷", "8" : "۸", "9" : "۹"]
        var str : String = self
        
        for (key,value) in numbersDictionary {
            str =  str.replacingOccurrences(of: key, with: value)
        }
        
        self = str
    }
    
    func getPersian()->String
    {
        let numbersDictionary : Dictionary = ["0" : "۰","1" : "۱", "2" : "۲", "3" : "۳", "4" : "۴", "5" : "۵", "6" : "۶", "7" : "۷", "8" : "۸", "9" : "۹"]
        var str : String = self
        
        for (key,value) in numbersDictionary {
            str =  str.replacingOccurrences(of: key, with: value)
        }
        
        return str
    }
}



extension UIView
{
    func fadeIn(_ duration:Double = 0.5)
    {
        self.alpha = 0
        self.isHidden = false
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        })
    }
    
    func fadeout(_ duration:Double = 0.5, _ hideAfterAnimate:Bool = true)
    {
        UIView.animate(withDuration: duration, animations: {
            
            self.alpha = 0
            
        }, completion: {finished in
            
            self.isHidden = hideAfterAnimate
        })
    }
}

class Util{}
extension Util
{
    static func persianDate(_ date:Date) -> String
    {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.calendar = NSCalendar(identifier: NSCalendar.Identifier.persian)! as Calendar
        
        
        dateFormatter.dateFormat = "yyyy"
        let year: String = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "MM"
        let month: String = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "dd"
        let day: String = dateFormatter.string(from: date)
        
        return year + "-" + month + "-" + day
    }
}


extension Date
{
    var persian:String
    {
        return Util.persianDate(self)
    }
}



extension String {
    var Bool:Bool! {
        switch self {
        case "True", "true", "TRUE", "yes", "Yes", "YES", "yeS", "yEs", "YEs", "YeS", "yES", "1":
            return true
        case "False", "false", "no", "No", "NO", "0", "", " ", "nO":
            return false
        case nil:
            return false
        default:
            return true
            //return nil
        }
    }
}

extension Bool{
    var String:String!{
        if self
        {
            return "true"
        }
        else
        {
            return "false"
        }
    }
}
