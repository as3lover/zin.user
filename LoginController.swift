//
//  LoginController.swift
//  zin
//
//  Created by Morteza on 6/12/1396 AP.
//  Copyright © 1396 Pasys. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation


import Firebase


class LoginController: CustomVC {
    
    @IBOutlet weak var bg: UIImageView!
    
    @IBOutlet weak var icon1: UIImageView!
    @IBOutlet weak var icon2: UIImageView!

    @IBOutlet weak var text1: UITextField!
    @IBOutlet weak var text2: UITextField!
    @IBOutlet weak var text3: UITextField!
    
    @IBOutlet weak var splitter: UIImageView!
    
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var buttomBt: UIButton!
    
    var player: AVPlayer!
    
    var notifObserver:NSObjectProtocol?
    
    
    enum State{
        case login, register, forgot
    }
    
    var state = State.register
    
    var status:State{
        
        get{
            return state
        }
        
        set(val){
            
            if (state == val)
            {
                return
            }

            state = val
            
            text1.text = ""
            text2.text = ""
            text3.text = ""
            
            switch state{
            case .login:
                icon1.image = UIImage(named: "cellPhone")
                icon2.image = UIImage(named: "key")
                
                text1.placeholder = Lang.Get(.input_app_phonenumber)//"شماره تلفن"
                text3.placeholder = Lang.Get(.title_app_password)//"رمز ورود"
                
                text1.keyboardType = UIKeyboardType.numberPad

                text2.isHidden = true
                splitter.isHidden = true
                
                let str1 = Lang.Get(.title_app_signin)//"ورود"
                let str2 = Lang.Get(.title_app_signup)//"ثبت نام"
                
                button.setTitle(str1,  for: .normal)
                buttomBt.setTitle(str2,  for: .normal)
                
                button.backgroundColor = UIColor(hex: "57B371")
                
                /*
                if Constants.Driver
                {
                    text1.text = "09155131373"
                    text3.text = "654321"
                }
                else
                {
                    text1.text = "09151112204"
                    text3.text = "123456"
                }
                */
                
                /*
                 (2:25 AM) 09366039481
                 (2:25 AM) 654321
                 (2:25 AM) OLD DRIVER
                 (2:25 AM) 09382700932
                 (2:25 AM) 123456
                 */
                
                var num:String!
                var pass:String!
                
                let old = false
                
                
                
                if Constants.Driver
                {
                    if old
                    {
                        num = "09382700932"
                        pass = "123456"
                    }
                    else
                    {
                        num = "09155131373"
                        pass = "654321"
                    }
                }
                else
                {
                    
                    if old
                    {
                        num = "09366039481"
                        pass = "654321"
                    }
                    else
                    {
                        num = "09151112204"
                        pass = "123456"
                    }
                    
                }
                
                text1.text = num
                text3.text = pass
                
                
                
            case .register:
                icon1.image = UIImage(named: "user")
                icon2.image = UIImage(named: "cellPhone")
                
                text1.placeholder = Lang.Get(.signup_name_edt)//"نام"
                text3.placeholder = Lang.Get(.input_app_phonenumber)//"شماره تلفن"
                
                text1.keyboardType = .alphabet
                
                text2.isHidden = false
                splitter.isHidden = false
        
                let str1 = Lang.Get(.title_app_signin)//"ورود"
                let str2 = Lang.Get(.title_app_signup)//"ثبت نام"
                
                button.setTitle(str2,  for: .normal)
                buttomBt.setTitle(str1,  for: .normal)

                
                button.backgroundColor = UIColor.blue
                
            case .forgot:
                break
            }
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        status = .login
        
        if Constants.Driver
        {
            
        }
        else
        {
            bg.alpha = 0
            play()
        }
    }
    
    private func play()
    {
        guard let path = Bundle.main.path(forResource: "video", ofType:"mp4") else
        {
            print("video.mp4 not found")
            return
        }
        
        player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        playerLayer.videoGravity =  AVLayerVideoGravityResizeAspectFill
        self.view.layer.insertSublayer(playerLayer, at: 1)
        //self.view.layer.addSublayer(playerLayer)
        
        player.play()
        
        self.notifObserver = NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player.currentItem, queue: nil, using: { (_) in
            DispatchQueue.main.async {
                self.player.seek(to: kCMTimeZero)
                self.player.play()
            }
        })
        
    }
    
    /*
    override func viewWillAppear(_ animated: Bool) {
        Lang.start()
        
        if Local.load("loggedIn") == "true"
        {
            startApp()
            return
        }
        
        status = .login
        
        if Constants.Driver
        {
            
        }
        else
        {
            bg.alpha = 0
            play()
        }
    }
    */
    
    override func viewDidDisappear(_ animated: Bool) {
        
        if Constants.Driver
        {
            return
        }
        
        DispatchQueue.main.async {
            NotificationCenter.default.removeObserver(self.notifObserver!)
            self.notifObserver = nil
            self.player.pause()
            self.player.replaceCurrentItem(with: nil)
            self.player = nil
        }
        
        super.viewDidDisappear(animated)
    }
    
    
    @IBAction func onLogingBT(_ sender: Any) {
        inProgress = true
        Requests.login(text1.text, text3.text, onComplete, Constants.Driver)
    }
    
    func onComplete(postStatus:PostStatus)
    {
        inProgress = false
        
        switch postStatus {
        case .Yes:
            DispatchQueue.main.async{
                Local.save("login", "true")
            }
            
            startApp()
        case .NoServer:
            Alert(Lang.Get(.ServerError), "", "OK")
        case .No:
            Alert(Lang.Get(.InvalidUserPassword), "", "OK")
        case .NoInternet:
            Alert(Lang.Get(.no_internet_connection), "", "OK")
        case .ServerError:
            Alert(Lang.Get(.ServerError), "", "OK")
        case .InternlError:
            Alert(Lang.Get(.error_in_progress), "", "OK")
        }
    }
    
    
    @IBAction func onRegisterBt(_ sender: Any) {
        
    }
    
    
    @IBAction func showRegister(_ sender: Any) {
        
        changeState()
        /*
        let when = DispatchTime.now() + 0.1 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.changeState()
        }
        */
    }
    
    func changeState()
    {
        switch status {
        case .login:
            status = .register
        case .register:
            status = .login
        default:
           break
        }
    }
    
    @IBAction func showLogin(_ sender: Any) {
    }
    
    
    func startApp()
    {
        if Constants.GCMtoken != nil{
            send.GCMToken()
        }
        DispatchQueue.main.async{
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "MainVC") as! MainView
            self.present(newViewController, animated: true, completion: nil)
        }
    }


}
