//
//  Profile.swift
//  zin
//
//  Created by Morteza on 6/19/1396 AP.
//  Copyright © 1396 Pasys. All rights reserved.
//

import UIKit

class Profile: CustomVC {
    
    
    @IBOutlet weak var fname: UITextField!
    @IBOutlet weak var lname: UITextField!
    @IBOutlet weak var mobile: UITextField!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var dob: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var tel: UITextField!
    
    
    @IBOutlet weak var ok: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mobile.isUserInteractionEnabled = false
        if Constants.Driver
        {
            ok.isHidden = true
            self.fname.isUserInteractionEnabled = false
            self.lname.isUserInteractionEnabled = false
            self.dob.isUserInteractionEnabled = false
            self.email.isUserInteractionEnabled = false
            self.tel.isUserInteractionEnabled = false
            self.gender.isUserInteractionEnabled = false
        }
        
        inProgress = true
        
        send.DriverProfileInfo(onComplete: loadData)

    }
    
    func loadData(_ status:PostStatus, _ profile:ProfileInfo?)
    {
        inProgress = false
        
        
        if let data = profile, status == .Yes
        {
            DispatchQueue.main.async {
                self.fname.text = data.firstName
                self.lname.text = data.lastName
                self.mobile.text = data.mobile
                self.dob.text = data.dob
                self.email.text = data.email
                self.tel.text = data.tel
                if data.gender == "1"
                {
                    self.gender.text = Lang.Get(.gender_male)//"مرد"
                }
                else if data.gender == "2"
                {
                    self.gender.text = Lang.Get(.gender_famele)
                }
                else
                {
                    self.gender.text = ""
                }
            }

        }
        else
        {
            Alert(Lang.Get(.Error), "", "OK")
        }
    }
    
    
    @IBAction func onOk(_ sender: Any) {
        
        inProgress = true
        
        var profile = ProfileInfo()
        
        profile.firstName = fname.text
        profile.lastName = lname.text
        profile.mobile = mobile.text
        profile.dob = dob.text
        profile.email = email.text
        profile.tel = tel.text
        
        if gender.text == Lang.Get(.gender_famele)
        {
            profile.gender = "2"
        }
        else
        {
            profile.gender = "1"
        }

        
        func saved(_ status:PostStatus)
        {
            inProgress = false
            
            if status == .Yes
            {
                Alert("اطلاعات ذخیره شد")
            }
            else
            {
                Alert(Lang.Get(.Error))
            }
        }
        
        send.EditProfile(profile, onComplete: saved)
    }

}
