//
//  Contact.swift
//  zin
//
//  Created by Morteza on 6/28/1396 AP.
//  Copyright © 1396 Pasys. All rights reserved.
//

import UIKit

class Contact: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    
    
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageTitle: UILabel!
    @IBOutlet weak var messageText: UITextView!
    
    var list = [Message]()

    override func viewDidLoad() {
        super.viewDidLoad()

        table.delegate = self
        table.dataSource = self
        
        messageView.isHidden = true
        
        SendMessage.parentVC = self
        
        load()
    }
    
    func load()
    {
        
        inProgress = true
        
        func loaded(_ status:PostStatus, _ messages:[Message]?)
        {
            inProgress = false
            
            if let messages = messages
            {
                list = messages
                DispatchQueue.main.async {
                    self.table.reloadData()
                }
            }
        }
        
        send.DriverSentMsg(loaded)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
        
        cell.caption.text = list[indexPath.row].title ?? ""
        cell.dateAndTime.text = list[indexPath.row].date ?? ""
        cell.messageText = list[indexPath.row].text ?? ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        showMassage(list[indexPath.row])
    }
    
    func showMassage(_ message:Message)
    {
        messageText.text = message.text
        messageTitle.text = message.title
        
        messageView.fadeIn(0.3)
    }
    
    @IBAction func onClose(_ sender: Any) {
        messageView.fadeout(0.3)
    }
    

}
