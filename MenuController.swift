//
//  MenuController.swift
//  zin
//
//  Created by Morteza on 5/19/1396 AP.
//  Copyright © 1396 Pasys. All rights reserved.
//

import UIKit

class MenuController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    
    @IBOutlet weak var tabelView: UITableView!
    let listUser = ["۰۹۳۹۱۰۳۶۷۱۲", "پروفایل", "نمایش سفرها", "پیام ها", "اعتبار", "سرویس های فعال", "خدمات زین", "تنظیمات" , "نسخه ۱.۰"];
    let listDriver = ["۰۹۳۹۱۰۳۶۷۱۲", "پروفایل", "نمایش سفرها", "پیام ها", "ارتباط با ما", "آدرس مسافر", "خدمات زین", "تنظیمات" , "نسخه ۱.۰"];
    let imagesUser = ["",  "home", "trips", "messages", "credit", "baloonGreen", "zinServices", "settingsMenu", ""]
    let imagesDriver = ["",  "home", "trips", "messages", "user", "baloonGreen", "zinServices", "settingsMenu", ""]
    
    var list:[String]
    {
        if Constants.Driver
        {
            return listDriver
        }
        else
        {
            return listUser
        }
    }
    
    var p:CGFloat = 0.1
    var tab:String = ""
    var rowHeight:CGFloat = 100
    
    var userData:ProfileAvatar?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tabelView.delegate = self
        tabelView.dataSource = self
        tabelView.separatorStyle = .none
        //tabelView.allowsSelection = false
        tabelView.alwaysBounceVertical = false
        
        let screenSize: CGRect = UIScreen.main.bounds
        let w = screenSize.width
        p = w / 375
        p = 1
        rowHeight = CGFloat(60 * p)
        tabelView.rowHeight = CGFloat(rowHeight)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        
        
        if row == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AvatarCell", for: indexPath) as! AvatarCell
            cell.isUserInteractionEnabled = false
            cell.label.text = list[row]
            cell.label.font = cell.label.font.withSize(14*p)
            
            
            
            func loaded(_ status:PostStatus, _ data:ProfileAvatar?)
            {
                inProgress = false
                if data != nil && status == .Yes
                {
                    userData = data
                    cell.set(data!)
                }
                else
                {
                    Alert("Error on getProfileAvatar()")
                }
            }
            if userData == nil
            {
                inProgress = true
                send.getProfileAvatar(onComplete: loaded, driver: Constants.Driver)
            }
            else
            {
                cell.set(userData!)
            }
            
            return cell
        }
        else if row == list.count-1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextCell
            cell.isUserInteractionEnabled = false
            cell.label.text = list[row]
            cell.label.font = cell.label.font.withSize(14*p)
            cell.label.textColor = UIColor.gray

            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
            cell.label.text = list[row]
            let img:UIImageView = cell.icon
            if Constants.Driver
            {
                img.image = UIImage(named: imagesDriver[row])
            }
            else
            {
                img.image = UIImage(named: imagesUser[row])
            }
            cell.label.font = cell.label.font.withSize(17*p)
            
            return cell
        }
        
        /*
        if(row > 0 && row<list.count-1)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
            cell.label.text = list[row]
            let img:UIImageView = cell.icon
            img.image = UIImage(named: images[row])
            cell.label.font = cell.label.font.withSize(17*p)
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell", for: indexPath) as! TextCell
            cell.isUserInteractionEnabled = false
            cell.label.text = list[row]
            if(row == list.count-1)
            {
                cell.label.font = cell.label.font.withSize(14*p)
                cell.label.textColor = UIColor.gray
            }
            else
            {
                cell.label.font = cell.label.font.withSize(17*p)
            }
            
            return cell
        }
 */
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return rowHeight * 2
        } else {
            return rowHeight//UITableViewAutomaticDimension
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tabelView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let vc:MenuPages = self.storyboard?.instantiateViewController(withIdentifier: "MenuPages") as? MenuPages
        {
            let row = indexPath.row
            var message:String?
            
            if row == 5 {
                if Constants.Driver
                {
                    message = "در حال حاضر درخواستی ثبت نشده است"
                }
                else
                {
                    message = "در حال حاضر شما هیچ سرویسی درخواست نکرده اید"
                }
            }
            else if row == 6
            {
                message = "این سرویس در حال توسعه می باشد"
            }
            
            if let message = message
            {
                Alert(message)
                return
            }

            vc.pageNum = row - 1
            
            self.present(vc, animated: true, completion: nil)            
        }
        /*
        var view:UIView?
        if let v = self.view{
            print("V")
            if let s = v.superview{
                print("S")
                view = s
            }
        }

        
        if let mainVC:MainView = self.storyboard?.instantiateViewController(withIdentifier: "MainVC") as? MainView
        {
            
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuPages")
            {
                
                
                if let view = view{
                    
                    mainVC.showPupUp(vc: vc, view:view)
                }
                else
                {
                    mainVC.showPupUp(vc: vc)
                }

            }
            else
            {
                print("no MenuPages")
            }
        }
        else
        {
            print("no mainVC")
        }
        
        
        return
        
        if let mainVC:MainView = self.storyboard?.instantiateViewController(withIdentifier: "MainVC") as? MainView
        {
            print(mainVC)
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuPages")
            {
                mainVC.currentPopUp = vc
                
                vc.modalPresentationStyle = .overCurrentContext
                present(vc, animated: true, completion: nil)
                
                mainVC.addChildViewController(vc)
                vc.didMove(toParentViewController: mainVC)
                
                vc.view.frame = mainVC.view.bounds
                mainVC.view.addSubview(vc.view)
                
                vc.view.frame.origin.y = -mainVC.view.frame.height
                
                UIView.animate(withDuration: 0.5, animations: {
                    vc.view.frame.origin.y = 0
                }, completion: nil)
            }
            
        }
        */
    }
    
    func hidePopUP(vc:UIViewController)
    {
        /*
 UIView.animate(withDuration: 0.5, animations: {
            vc.view.frame.origin.y = self.view.frame.height
        }, completion: {finished in
            
            vc.view.removeFromSuperview()
            vc.removeFromParentViewController()
            if let mainVC:MainView = self.storyboard?.instantiateViewController(withIdentifier: "MainVC") as? MainView
            {
                mainVC.currentPopUp = nil
            }
        })
         */
    }
    
    
}

