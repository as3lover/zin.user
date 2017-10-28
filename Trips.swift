//
//  Trips.swift
//  zin
//
//  Created by Morteza on 6/28/1396 AP.
//  Copyright © 1396 Pasys. All rights reserved.
//

import UIKit

class Trips: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var header: UIView!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var footer: UIView!
    
    var list = [Trip]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.dataSource = self
        table.delegate = self
        
        header.isHidden = !Constants.Driver
        footer.isHidden = !Constants.Driver
        
        DatePicker.parent = self

        print(list.count, list)
        loadTrips()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return list.count
        
        /*
        if list.count == 0 && Constants.Driver
        {
            return 1
        }
        else
        {
            return list.count
        }*/
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        var cell:UITableViewCell
        let trip = list[row]

        if Constants.Driver
        {
            if row == 0 && false
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "TripCellTitle", for: indexPath)
            }
            else
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "TripCellDriver", for: indexPath) as! TripCellDriver
                
                if let cell = cell as? TripCellDriver
                {
                    cell.type.text = trip.type
                    cell.price.text = trip.cost
                    cell.time.text = trip.date
                    cell.address.text = (trip.from ?? "") + " / " + (trip.to ?? "")
                }
            }
        }
        else
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "TripCell", for: indexPath) as! TripCell
            
            if let cell = cell as? TripCell
            {
                cell.from.text = trip.from ?? ""
                cell.to.text = trip.to ?? ""
                cell.date.text = "تاریخ  " + (trip.date ?? "")
                cell.cost.text = "مبلغ  " + (trip.cost ?? "")
            }
        }
        
        print(cell)
        
        return cell
    }

    
    func loadTrips()
    {
        inProgress = true
        
        func reload()
        {
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        }
        
        func loaded(_ status:PostStatus, _ trips:[Trip]?)
        {
            inProgress = false
            
            if let trips = trips, status == .Yes
            {
                self.list = trips
                reload()
            }
            else if status == .NoInternet
            {
                Alert(Lang.Get(.no_internet_connection))
            }
            else
            {
                self.list.removeAll()
                reload()
                
                var message:String = Lang.Get(.no_active_service)
                if Constants.Driver
                {
                    message = "سرویسی در این روز انجام نشده است"
                }

                Alert(message)
            }
        }
        
        
        
        if Constants.Driver
        {
            send.DriverDoneServices(date: Constants.SelectedDate.persian, onComplete: loaded)
        }
        else
        {
            send.TripInfo(onComplete: loaded)
        }
    }
    
    
    @IBAction func onCalendar(_ sender: Any) {
        
    }


}
