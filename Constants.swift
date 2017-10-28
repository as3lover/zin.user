//
//  Constants.swift
//  zin
//
//  Created by Morteza on 6/25/1396 AP.
//  Copyright © 1396 Pasys. All rights reserved.
//

import Foundation
class Constants
{
    static var Driver = false
    
    private static var _language = strToLang(Local.load("lang"))
    static var language:Language
    {
        get{
            return _language
        }
        
        set(val)
        {
            _language = val
            Local.save("lang", lang)
        }
    }
    
    public static var GCMRegistered:Bool = false
    static public var GCMtoken:String? = nil

    static var LoggedIn:Bool
    {
        if Local.load("login") == "true"
        {
            return true
        }
        return false
    }
    
    static var lang:String
    {
        return Constants.language.rawValue
    }
    
    static var SelectedDate = Date()
    static var SelectedPersianDate:String{
        return SelectedDate.persian
    }
    
    
    static func strToLang(_ string:String?)->Language
    {
        let str:String! = string ?? "fa"
        
        switch str {
        case "en":
            return .English
        case "ar":
            return .Arabic
        case "tr":
            return .Turkish
        default:
            return .Persian
        }
    }
    
}

extension NSObject
{
    static var lang:String
    {
        return Constants.language.rawValue
    }
    
    static var language:Language
    {
        return Constants.language
    }
}

enum Language:String
{
    case Persian = "fa"
    case English = "en"
    case Arabic = "ar"
    case Turkish = "tr"
}
