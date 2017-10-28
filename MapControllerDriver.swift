//
//  MapControllerDriver.swift
//  zin
//
//  Created by Morteza on 6/31/1396 AP.
//  Copyright © 1396 Pasys. All rights reserved.
//

import UIKit
import MapKit

class MapControllerDriver: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    @IBOutlet weak var map: MKMapView!
    
    
    let regionRadius:CLLocationDistance = 3000; //Meter
    var gotomyPosition = true
    var currentLocation:CLLocation = CLLocation(latitude: 36.3045, longitude: 59.5819);
    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        map.delegate = self
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
    }
    
    
    func centerMapOnLocation(_ location:CLLocation)
    {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        DispatchQueue.main.async()
            {
                self.map.setRegion(coordinateRegion, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations[0]
        if gotomyPosition{
            gotomyPosition = false
            centerMapOnLocation(currentLocation)
        }
    }

    @IBAction func showLoaction(_ sender: Any) {
        centerMapOnLocation(currentLocation)
        gotomyPosition = true
    }
    
    
  
}
