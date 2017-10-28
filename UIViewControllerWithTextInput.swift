//
//  UIViewControllerWithTextInput.swift
//  zin
//
//  Created by Morteza on 5/26/1396 AP.
//  Copyright © 1396 Pasys. All rights reserved.
//

import UIKit

class UIViewControllerWithTextInput: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        setTextFieldsDelegate()
        //addDoneButtonOnKeyboard()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField
        {
            nextField.becomeFirstResponder()
        } else
        {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
        
        /*
        let list = getChildByType(parent: self.view, type: UITextField.self)
        for txt in list{
            txt.resignFirstResponder()
        }
        return(true)*/
    }
    
    /*
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x:0, y:0, width:320, height:50))
        doneToolbar.barStyle = UIBarStyle.blackTranslucent
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(UIViewControllerWithTextInput.doneButtonAction))
        
        let items = NSMutableArray()
        items.add(flexSpace)
        items.add(done)
        
        doneToolbar.items = items as? [UIBarButtonItem]
        doneToolbar.sizeToFit()
        
        let list = getChildByType(parent: self.view, type: UITextField.self)
        for txt in list{
            txt.inputAccessoryView = doneToolbar
        }
        
        let list2 = getChildByType(parent: self.view, type: UITextView.self)
        for txt in list2{
            txt.inputAccessoryView = doneToolbar
        }
    }
    
    
    
    
    func doneButtonAction()
    {
        //self.textViewDescription.resignFirstResponder()
        //self.textViewDescription.resignFirstResponder()
        print(101010101)
        let list = getChildByType(parent: self.view, type: UITextField.self)
        for txt in list{
            txt.resignFirstResponder()
        }
    }
    */
}

class CustomVC:UIViewControllerWithTextInput
{
    
}
