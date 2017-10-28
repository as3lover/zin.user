//
//  Messages.swift
//  zin
//
//  Created by Morteza on 6/25/1396 AP.
//  Copyright © 1396 Pasys. All rights reserved.
//

import UIKit

class Messages: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageTitle: UILabel!
    @IBOutlet weak var messageText: UITextView!

    
    private var  _list = [Message]()
    
    var list:[Message]{
        get{
            return _list
        }
        set(val){
            _list = val
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        messageView.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        
        
        cell.caption.text = list[indexPath.row].title
        cell.date.text = list[indexPath.row].date
        cell.messageText = list[indexPath.row].text ?? ""

        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showMessage(list[indexPath.row])
    }
    
    func showMessage(_ msg:Message)
    {
        messageTitle.text = (msg.title ?? "")
        messageText.text = msg.text
        
        messageView.fadeIn(0.3)
    }
    
    @IBAction func hideMessage(_ sender: Any) {
        messageView.fadeout(0.3)
    }

}
