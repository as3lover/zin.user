//
//  FavService.swift
//  zin
//
//  Created by Morteza on 7/1/1396 AP.
//  Copyright © 1396 Pasys. All rights reserved.
//

import UIKit

class FavService: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var reqBt: UIButton!
    
    @IBOutlet weak var table: UITableView!
    
    var list = [FavLoc]()

    override func viewDidLoad() {
        super.viewDidLoad()

        table.delegate = self
        table.dataSource = self
        
        inProgress = true
        send.getFavoriteLocation(onComplete: onLoadLocs)
    }
    
    func onLoadLocs(_ status:PostStatus, _ locations: [FavLoc]?)
    {
        inProgress = false
        
        if let locations = locations , status == .Yes
        {
            list = locations
            
            if locations.count > 0
            {
                
            }
            else
            {
                Alert("Empty Fav Place")
            }
        }
        else
        {
            list.removeAll()
            Alert("Error")
        }
        
        table.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavLocCell", for: indexPath) as! FavLocCell
        cell.favLoc = list[indexPath.row]
        
        return cell
    }

    @IBAction func onRequestBt(_ sender: Any) {
    }
    
    
    @IBAction func onClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
