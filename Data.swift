//
//  Data.swift
//  zin
//
//  Created by Morteza on 6/13/1396 AP.
//  Copyright © 1396 Pasys. All rights reserved.
//

import Foundation

class Local
{   
    static var mobile:String?{
        return load("mobile")
    }
    
    static var token:String?{
        return load("token")
    }
    
    static func save(_ key:String, _ value:String)
    {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key)
        defaults.synchronize()
        //defaults.register(defaults: [key : value])
        //defaults.synchronize()
        
        print("SAVE: ", key, value)
        
        return
        DispatchQueue.main.async{
            
            let defaults = UserDefaults.standard
            
            if defaults.string(forKey: key) != nil
            {
                defaults.set(value, forKey: key)
                defaults.synchronize()
            }
            else
            {
                let newValue = [key : value]
                defaults.register(defaults: newValue)
            }
            
        }
    }
    
    static func saveDic(_ key:String, _ val:[String:String])
    {
        toSaveAny(key, val, loadDic(key))
    }
    
    private static func saveObject(_ key:String, _ val:Any, type:String)
    {
        var old:Any?
        switch type {
        case "String":
            old = loadString(key)
        case "String":
            old = loadDic(key)
        default:
            old = nil
        }
        
        toSaveAny(key, val, old)
    }
    
    
    /////////// SAVE Any
    private static func toSaveAny(_ key:String, _ val:Any, _ old:Any?)
    {
        if old == nil
        {
            saveAny(key, val)
        }
        else
        {
            resaveAny(key, val)
        }
    }
    
    private static func saveAny(_ key:String, _ val:Any)
    {
        let newValue = [key : val]
        UserDefaults.standard.register(defaults: newValue)
    }
    
    private static func resaveAny(_ key:String, _ val:Any)
    {
        UserDefaults.standard.set(val, forKey: key)
        UserDefaults.standard.synchronize()
    }
    /////////////////
    
    
    
    static func clear(_ key:String)
    {
        print("CLEAR: ", key)
        let defaults = UserDefaults.standard
        
        if defaults.string(forKey: key) != nil
        {
            defaults.removeObject(forKey: key)
        }
    }
    
    static func load(_ key:String)->String?
    {
        let defaults = UserDefaults.standard
        let value = defaults.string(forKey: key)
        
        print("LOAD: ", key, value ?? "NO EXIST")
        
        return value
    }
    
    
    /////////////////// LOAD
    static func loadDic(_ key:String)->[String:String]?
    {
        return UserDefaults.standard.dictionary(forKey: key)as! [String : String]?
    }
    
    static func loadString(_ key:String)->String?
    {
        return UserDefaults.standard.string(forKey: key)
    }
    
    static func loadBool(_ key:String)->Bool?
    {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    static func loadInt(_ key:String)->Int?
    {
        return UserDefaults.standard.integer(forKey: key)
    }
    
    static func loadDouble(_ key:String)->Double?
    {
        return UserDefaults.standard.double(forKey: key)
    }
    
}
