//
//  Settings.swift
//  zin
//
//  Created by Morteza on 6/29/1396 AP.
//  Copyright © 1396 Pasys. All rights reserved.
//

import UIKit

class Settings: UIViewController {
    
    @IBOutlet weak var newsSwitch: UISwitch!
    @IBOutlet weak var msgSwitch: UISwitch!
    @IBOutlet weak var langButton: UIButton!
    var language:Language = .Persian
    
    @IBOutlet weak var langSelector: UIView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        langSelector.isHidden = true
        
        language = Constants.language
        
        reload()
    }
    
    func reload()
    {
        if !langSelector.isHidden
        {
            langSelector.fadeout(0.3)
        }

        switch language {
        case .Persian:
            langButton.setImage(UIImage(named:"persian"), for: .normal)
        case .Arabic:
            langButton.setImage(UIImage(named:"arabic"), for: .normal)
        case .English:
            langButton.setImage(UIImage(named:"english"), for: .normal)
        case .Turkish:
            langButton.setImage(UIImage(named:"turkish"), for: .normal)
        }
        
        msgSwitch.isOn = (Local.load("message"))?.Bool ?? true
        newsSwitch.isOn = (Local.load("news"))?.Bool ?? true
    }
    
    
    @IBAction func onLang(_ sender: Any) {

        langSelector.fadeIn(0.3)
    }
    
    @IBAction func onPersian(_ sender: Any) {
        language = .Persian
        reload()
    }
    
    @IBAction func onEnglish(_ sender: Any) {
        language = .English
        reload()
    }
    
    @IBAction func onArabic(_ sender: Any) {
        language = .Arabic
        reload()
    }
    
    @IBAction func onTurkich(_ sender: Any) {
        language = .Turkish
        reload()
    }
    
    @IBAction func onSave(_ sender: Any) {
        Constants.language = language
        Local.save("message", msgSwitch.isOn.String)
        Local.save("news", newsSwitch.isOn.String)
        self.dismiss(animated: true, completion: nil)
    }
    


}
