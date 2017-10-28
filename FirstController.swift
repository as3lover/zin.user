//
//  FirstController.swift
//  zin.user
//
//  Created by NIC on 10/26/17.
//  Copyright © 2017 pasys. All rights reserved.
//

import UIKit
import Firebase

class FirstController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        print(">>>>>>>>>>>>>>>>>>>>>>>>>>START")
        let token = Messaging.messaging().fcmToken
        print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>FCM token: \(token ?? "")")
        
        Lang.start()
        
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.startt()
        })
    }
    
    
    func startt()
    {
        print("start++++++++++++++")
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        if Local.load("login") == "true"
        {
            if Constants.GCMtoken != nil{
                send.GCMToken()
            }
            let vc = storyBoard.instantiateViewController(withIdentifier: "MainVC") as! MainView
            self.present(vc, animated: true, completion: nil)
            
        }
        else
        {
            let vc = storyBoard.instantiateViewController(withIdentifier: "loginVC") as! LoginController
            self.present(vc, animated: true, completion: nil)
            
        }
    }

    


}
