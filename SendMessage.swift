//
//  SendMessage.swift
//  zin
//
//  Created by Morteza on 6/29/1396 AP.
//  Copyright © 1396 Pasys. All rights reserved.
//

import UIKit

class SendMessage: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var messageTitle: UITextField!
    @IBOutlet weak var messageText: UITextView!
    
    static var parentVC:Contact?
    
    let placeHolder = "نظرات و پیشنهادات خود را برای ما بفرستید"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTitle.text = ""
        messageText.text = placeHolder
        messageText.textColor = .lightGray
        
        messageText.delegate = self
    }
    
    @IBAction func onSendBt(_ sender: Any) {
        
        if messageText.text == "" || messageText.text == " " || messageText.text == placeHolder
        {
            Alert("پیامی درج نشده است")
            return
        }
        
        inProgress = true
        
        if messageTitle.text == "" || messageTitle.text == " "
        {
            messageTitle.text = messageTitle.placeholder
        }
        
        func complete(_ status:PostStatus)
        {
            inProgress = false
            
            if status == .Yes
            {
                self.dismiss(animated: true, completion: {
                    SendMessage.parentVC?.load()
                })
            }
            else
            {
                Alert(Lang.Get(.Error))
            }
        }
        
        send.DriverSendMsg(subject: messageTitle.text!, text: messageText.text!, onComplete: complete)
        
        
    }
    
    @IBAction func onClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        textView.textColor = .black
        
        if (textView.text == placeHolder)
        {
            textView.text = ""
        }
        textView.becomeFirstResponder() //Optional
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if (textView.text == "")
        {
            textView.text = placeHolder
            textView.textColor = .lightGray
        }
        textView.resignFirstResponder()
    }
    
    

}
