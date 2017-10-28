//
//  DatePicker.swift
//  zin
//
//  Created by Morteza on 6/28/1396 AP.
//  Copyright © 1396 Pasys. All rights reserved.
//

import UIKit

class DatePicker: UIViewController {
    
    static var parent:Trips?
    var changed = false
    
    @IBOutlet weak var picker: UIDatePicker!
    @IBOutlet weak var currentDate: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.setDate(Constants.SelectedDate, animated: false)

        picker.calendar = NSCalendar(identifier: NSCalendar.Identifier.persian)! as Calendar!
        picker.locale = NSLocale(localeIdentifier: "fa_IR") as Locale
        picker.datePickerMode = .date
        changed = false
        
        showDate()
    }
    
    @IBAction func onChangeValue(_ sender: Any) {

        if Constants.SelectedDate.persian != self.picker.date.persian
        {
            changed = true
            Constants.SelectedDate = self.picker.date
            showDate()
        }
    }
    
    func showDate()
    {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.calendar = NSCalendar(identifier: NSCalendar.Identifier.persian)! as Calendar
        
        dateFormatter.locale = NSLocale(localeIdentifier: "fa_IR") as Locale!

        currentDate.text = dateFormatter.string(from: Constants.SelectedDate)
    }
    
    
    @IBAction func ok(_ sender: Any) {
        
        self.dismiss(animated: true, completion: {
            if self.changed{
                DatePicker.parent?.loadTrips()
            }
        })
    }
    

}
