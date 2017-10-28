//
//  MultiService.swift
//  zin
//
//  Created by Morteza on 6/14/1396 AP.
//  Copyright © 1396 Pasys. All rights reserved.
//

import UIKit

class MultiService: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource
{
    
    
    @IBOutlet weak var picker: UIPickerView!

    var nums: [Int] = Array(1...10)
    static var currentNum = 1


    override func viewDidLoad() {
        super.viewDidLoad()

        picker.delegate = self
        picker.dataSource = self
        
        picker.selectRow(MultiService.currentNum-1, inComponent: 0, animated: true)
        /*
        picker.subviews[0].subviews[1].backgroundColor = UIColor.blue
        picker.subviews[0].subviews[2].backgroundColor = UIColor.blue
 */
        
    }
    

    
    //MARK: - Request
    @IBAction func onReqBt(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Close
    @IBAction func onCloseBt(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    //MARK: - Picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return nums.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(nums[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        MultiService.currentNum = nums[row]
        print(MultiService.currentNum)
    }


}
