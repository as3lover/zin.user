//
//  ViewController.swift
//  zin.user
//
//  Created by NIC on 10/24/17.
//  Copyright © 2017 pasys. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func handleLogTokenTouch(_ sender: UIButton) {
        // [START log_fcm_reg_token]
        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")
        // [END log_fcm_reg_token]
        
    }
    
    @IBAction func handleSubscribeTouch(_ sender: UIButton)
    {
        // [START subscribe_topic]
        Messaging.messaging().subscribe(toTopic: "news")
        print("Subscribed to news topic")
        // [END subscribe_topic]
        
    }
    
}

