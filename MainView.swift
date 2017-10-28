//
//  MainView.swift
//  zin
//
//  Created by Morteza on 5/22/1396 AP.
//  Copyright © 1396 Pasys. All rights reserved.
//

import UIKit
import MapKit

class MainView: UIViewController, CLLocationManagerDelegate {
    
    private let LEFT = "left"
    private let RIGHT = "right"
    private let UP = "up"
    private let DOWN = "down"
    private let SELF = "self"
    
    var w :CGFloat = 0.0
    var h :CGFloat = 0.0
    var currentPage = 2
    var direction = ""
    var bt: UIButton?
    var currentPopUp:UIViewController?
    
    
    @IBOutlet weak var blueBar: UIImageView!
    
    @IBOutlet weak var contentView: UIView!
    
    static var currentViewController: UIViewController?
    var prevViewController: UIViewController?
    
    lazy var firstChildTabVC: UIViewController? = {
        var mapVC:String!
        if Constants.Driver {
            mapVC = "mapViewDriver"
        }
        else{
            mapVC = "mapView"
        }
        let firstChildTabVC = self.storyboard?.instantiateViewController(withIdentifier: mapVC)
        return firstChildTabVC
    }()
    lazy var secondChildTabVC : UIViewController? = {
        var homeView:String! = "homeView"
        if Constants.Driver {
            homeView = "homeViewDriver"
        }

        let secondChildTabVC = self.storyboard?.instantiateViewController(withIdentifier: homeView)
        
        return secondChildTabVC
    }()
    lazy var thirdChildTabVC : UIViewController? = {
        let thirdChildTabVC = self.storyboard?.instantiateViewController(withIdentifier: "menuView")
        
        return thirdChildTabVC
    }()
    
    lazy var prof : UIViewController? = {
        let prof = self.storyboard?.instantiateViewController(withIdentifier: "MenuPages")
        
        return prof
    }()

    
    
    @IBOutlet weak var btMap: UIButton!
    @IBOutlet weak var btHome: UIButton!
    @IBOutlet weak var btMenu: UIButton!
    
    static var vc:MainView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        MainView.vc = self
        
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipe))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipe))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        let screenSize: CGRect = UIScreen.main.bounds
        w = screenSize.width
        h = screenSize.height

        centerFitButtonImage(bt: btMap)
        centerFitButtonImage(bt: btHome)
        centerFitButtonImage(bt: btMenu)

        gotoHome(btHome)
        
         
    }
    
    func showPupUp(vc:UIViewController)
    {
        direction = UP
        
    }
    
    func showPupUp(vc:UIViewController, view:UIView)
    {
        direction = UP
        if let vcc = prof{
            displayTab(vc: vcc)
        }
        else
        {
            print("NO MenuPages")
        }
        /*
        addChildViewController(vc)
        vc.didMove(toParentViewController: self)
        vc.view.frame = view.bounds
        view.addSubview(vc.view)
        currentViewController = vc
        
        showPage(vc : vc)*/
    }
    
    func hidePopUP()
    {
        direction = DOWN
        if let vc = thirdChildTabVC{
            displayTab(vc: vc)
        }
    }
    
    
    
    func respondToSwipe(ges: UISwipeGestureRecognizer)
    {
        if(currentPopUp != nil)
        {
            return
        }
        
        if let swipe = ges as UISwipeGestureRecognizer!
        {
            switch swipe.direction
            {
            case UISwipeGestureRecognizerDirection.right:
                switchTabs(Item: currentPage-1)
            case UISwipeGestureRecognizerDirection.left:
                switchTabs(Item: currentPage+1)
            default:
                //print(swipe.direction)
                break
            }
        }
    }
    
    func centerFitButtonImage(bt:UIButton)
    {
        var x = bt.frame.size.width - (bt.imageView?.frame.size.width)!
        x /= 2
        bt.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        bt.imageEdgeInsets = UIEdgeInsets(top: 0, left: x, bottom: 0, right: x)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let currentViewController = MainView.currentViewController {
            currentViewController.viewWillDisappear(animated)
        }
    }
    
    @IBAction func gotoMenu(_ sender: Any) {
        switchTabs(Item:3)
    }

    @IBAction func gotoHome(_ sender: Any) {
        switchTabs(Item:2)
    }
    
    @IBAction func gotoMap(_ sender: Any) {
        switchTabs(Item:1)
    }
    
    func switchTabs(Item:Int) {
        
        var item = Item
        
        if(item<1)
        {
            item = 1
        }
        else if(item > 3)
        {
            item = 3
        }
        
        if(item == 1)
        {
            bt = btMap
        }
        else if(item == 2)
        {
            bt = btHome
        }
        else
        {
            bt = btMenu
        }
        
        if let vc = MainView.currentViewController {
            prevViewController = vc
            
            if(currentPage > item)
            {
                direction = LEFT
            }
            else if (currentPage < item)
            {
                direction = RIGHT
            }
            else
            {
                return
            }
        }
        else
        {
            direction = SELF
        }
        
        currentPage = item

        self.bt?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.75, delay:0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.blueBar.frame.origin.x = CGFloat(CGFloat(item - 1) * self.blueBar.frame.width)
            self.bt?.transform = CGAffineTransform.identity
        }, completion: nil)
        
        if let vc = viewControllerForSelectedSegmentIndex(item) {
            displayTab(vc: vc)
        }
    }
    
    
    
    func displayTab(vc :UIViewController){
        addChildViewController(vc)
        vc.didMove(toParentViewController: self)
        vc.view.frame = contentView.bounds
        contentView.addSubview(vc.view)
        MainView.currentViewController = vc
        
        showPage(vc : vc)

    }
    
    
    
    
    
    
    
    
    
    func showPage(vc:UIViewController)
    {
        //print("----------- INTERNET: ", internet(), "GPS: ", gps())
        //print("GPS: -----------", GPS, gpsStatus)
        
        switch direction {
        case LEFT:
            vc.view.frame.origin.x = -self.w
            vc.view.frame.origin.y = 0
            vc.view.alpha = 1
        case RIGHT:
            vc.view.frame.origin.x = +self.w
            vc.view.frame.origin.y = 0
            vc.view.alpha = 1
        case UP:
            vc.view.frame.origin.x = 0
            vc.view.frame.origin.y = -self.h
            vc.view.alpha = 1
        case DOWN:
            vc.view.frame.origin.x = 0
            vc.view.frame.origin.y = +self.h
            vc.view.alpha = 1
        default:
            vc.view.frame.origin.x = 0
            vc.view.frame.origin.y = 0
            vc.view.alpha = 0
        }
        
        
        UIView.animate(withDuration: 0.5, animations: {
            vc.view.frame.origin.x = 0
            vc.view.frame.origin.y = 0
            vc.view.alpha = 1
        }, completion: nil)
        
        hidePage()
    }
    
    func hidePage()
    {
        if let vc = self.prevViewController{
            UIView.animate(withDuration: 0.5, animations: {
                
                self.prevViewController = nil
                
                switch self.direction {
                case self.LEFT:
                    vc.view.frame.origin.x = +self.w
                case self.RIGHT:
                    vc.view.frame.origin.x = -self.w
                case self.UP:
                    vc.view.frame.origin.y = -self.w
                case self.DOWN:
                    vc.view.frame.origin.y = +self.w
                    
                default:
                    vc.view.alpha = 0
                }
                
            }, completion: {finished in
                
                vc.view.removeFromSuperview()
                vc.removeFromParentViewController()
            })
        }
    }
    
    
    func viewControllerForSelectedSegmentIndex(_ index: Int) -> UIViewController? {
        var vc: UIViewController?
        switch index {
        case 1 :
            vc = firstChildTabVC
        case 2 :
            vc = secondChildTabVC
        case 3 :
            vc = thirdChildTabVC
        default:
            return nil
        }
        
        return vc
    }


}
