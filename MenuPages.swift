//
//  MenuPages.swift
//  zin
//
//  Created by Morteza on 5/23/1396 AP.
//  Copyright © 1396 Pasys. All rights reserved.
//

import UIKit

class MenuPages: UIViewController {
    
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var label: UILabel!
    
    
    var currerntPage:UIViewController?
    var newPage:UIViewController?
    var pageNum:Int?
    
    let pagesUser = ["profile", "trips", "messages", "credit", "services", "zinServices", "settings", "about"]
    let pagesDriver = ["profile", "trips", "messages", "contact", "services", "zinServices", "settings", "about"]
    
    //let pagesLabelUser = ["پروفایل", "سفرها", "پیام ها", "اعتبار", "سرویس های فعال", "خدمات زین", "تنظیمات", "درباره ما"]
    let pagesLabelUser:[String] = [Lang.Get(.nav_profile),Lang.Get(.showtrips),Lang.Get(.messages),Lang.Get(.credits),Lang.Get(.active_services),Lang.Get(.zin_services),Lang.Get(.setting), "درباره ما"]
    let pagesLabelDriver:[String] = [Lang.Get(.nav_profile), Lang.Get(.showtrips), Lang.Get(.messages), "ارتباط با ما", Lang.Get(.active_services), Lang.Get(.zin_services), Lang.Get(.setting), "درباره ما"]
    //let pagesLabelDriver = ["پروفایل", "سفرها", "پیام ها", "ارتباط با ما", "سرویس های فعال", "خدمات زین", "تنظیمات", "درباره ما"]
    
    var pagesLabel:[String]
    {
        if Constants.Driver
        {
            return pagesLabelDriver
        }
        return pagesLabelUser
    }
    
    var pages:[String]
    {
        if Constants.Driver
        {
            return pagesDriver
        }
        return pagesUser
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        //view.isOpaque = false
        
        
    
        if let page = currerntPage{
            page.view.removeFromSuperview()
            page.removeFromParentViewController()
            currerntPage = nil
        }
        else
        {
            print("No current page")
        }
        
        
        let vc:UIViewController? = getVc()
        if let vc = vc{
            currerntPage = vc
            
            setVC(vc)
            
        }
        else
        {
            print("No new Page")
        }
        
    }
    
    func getVc()-> UIViewController?
    {
        if let index = pageNum
        {
            if index >= pages.count || index < 0
            {
                return nil
            }
            
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: pages[index])
            {
                /*let screenSize: CGRect = UIScreen.main.bounds
                let w = screenSize.width
                var p = w / 375
                p = 1
                if p > 25{
                    p = 25
                }
                self.label.font = self.label.font.withSize(p*17)*/
                self.label.text = pagesLabel[index]
                return vc
            }
        }
        return nil
    }
   
    
    func setVC(_ vc:UIViewController)
    {
        switch vc {
        case is Messages:
            loadMessages()            
        default:
            showVC(vc)
        }
    }
    
    func showVC(_ vc:UIViewController)
    {
        DispatchQueue.main.async {
            self.addChildViewController(vc)
            vc.view.frame = self.container.bounds
            self.container.addSubview(vc.view)
            vc.didMove(toParentViewController: self)
        }
    }
    
    
    @IBAction func onClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        /*
         if let mainVC:MainView = self.storyboard?.instantiateViewController(withIdentifier: "MainVC") as? MainView
         {
         mainVC.hidePopUP()
         }
         else{
         print("no")
         }
         */
    }
    
    
    
    ////////
    func loadMessages()
    {
        inProgress = true
        
        func loaded(_ status:PostStatus, _ messages:[Message]?)
        {
            inProgress = false
            
            if let messages = messages, status == .Yes
            {
                if let vc = currerntPage as? Messages
                {
                    vc.list = messages
                    showVC(vc)
                }
            }
            else if status == .NoInternet
            {
                Alert(Lang.Get(.no_internet_connection))
            }
            else
            {
                Alert(Lang.Get(.Error))
            }
        }
        
        send.MessageList(onComplete: loaded, driver: Constants.Driver)
    }
    ////////
    
    
    
    
    
}
