//
//  MapContoller.swift
//  zin
//
//  Created by Morteza on 5/19/1396 AP.
//  Copyright © 1396 Pasys. All rights reserved.
//

import UIKit
import MapKit


class MapContoller: CustomVC, CLLocationManagerDelegate, MKMapViewDelegate{
    
    @IBOutlet weak var origin: UITextField!
    @IBOutlet weak var dest: UITextField!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var addressList: UIStackView!
    @IBOutlet weak var centerPin: UIImageView!
    
    @IBOutlet weak var textHolder: UIImageView!
    
    @IBOutlet weak var originCloseBt: UIButton!
    
    
    @IBOutlet weak var destCloseBt: UIButton!

    
    enum Status{
        case Origin, Dest, Price, Service, Finish
    }
    
    var state = Status.Origin
    
    var status:Status {
        get{
            return state
        }
        set(value){
            state = value
            setStatus()
        }
    }
    
    var userPins = [MKAnnotation]()
    var agancyPins = [MKAnnotation]()
    var carPins = [MKAnnotation]()
    
    var gotomyPosition = true
    
    var priceVC:PriceController?
    var priceView:UIView?
    
    var driverVC:DriverController?
    var driverView:UIView?
    
    
    private var locationManager = CLLocationManager()
    let regionRadius:CLLocationDistance = 3000; //Meter
    var currentLocation:CLLocation = CLLocation(latitude: 36.3045, longitude: 59.5819);
    var pointAnnotation:CustomPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    var ids:[String]?
    var searching = false
    var currentField:UITextField?
    var moving = false
    
    var originLoc = CLLocationCoordinate2D(latitude: 0,longitude: 0)
    var destLoc = CLLocationCoordinate2D(latitude: 0,longitude: 0)
    
    
    
    
    //MARK: - Start
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        map.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        map.mapType = MKMapType.standard
        map.showsTraffic = true
        
        addressList.isHidden = true
        
        setStatus()
        
        //initLocationManager()
        
        
        /*
         let screenSize: CGRect = UIScreen.main.bounds
         let w = screenSize.width
         let p = w / 375
         
         origin.font = origin.font?.withSize(14 * p)
         dest.font = dest.font?.withSize(14 * p)
         greenButton.titleLabel?.font = greenButton.titleLabel?.font?.withSize(15 * p)
         
         */

        
    }
    
    
    
    func setStatus()
    {
        greenButton.isEnabled = true
        origin.isUserInteractionEnabled = false
        dest.isUserInteractionEnabled = false
        origin.textColor = UIColor.gray
        dest.textColor = UIColor.gray
        
        map.removeAnnotations(userPins)
        let pin1 = createPin(coordinate: originLoc, "male 60px").annotation!
        let pin2 = createPin(coordinate: destLoc, "baloonRed 60px").annotation!
        userPins = [pin1, pin2]
        map.addAnnotation(pin1)
        map.addAnnotation(pin2)
        
        originCloseBt.isHidden = true
        destCloseBt.isHidden = false
        
        switch status {
            
        case .Origin:
            centerPin.image = UIImage(named: "male 60px")
            centerPin.isHidden = false
            map.removeAnnotations(userPins)
            greenButton.setTitle("تأیید مبدأ", for: .normal)
            origin.isUserInteractionEnabled = true
            origin.textColor = UIColor.darkText
            map.removeOverlays(map.overlays)
            destCloseBt.isHidden = true
            
        case .Dest:
            centerPin.image = UIImage(named: "baloonRed 60px")
            centerPin.isHidden = false
            map.removeAnnotation(pin2)
            greenButton.setTitle("تأیید مقصد", for: .normal)
            dest.isUserInteractionEnabled = true
            dest.textColor = UIColor.darkText
            map.removeOverlays(map.overlays)
            showRout()
            originCloseBt.isHidden = false
            destCloseBt.isHidden = true
            
        case .Price:
            centerPin.isHidden = true
            greenButton.setTitle("محاسبه قیمت", for: .normal)
            
        case .Service:
            centerPin.isHidden = true
            greenButton.setTitle("درخواست سرویس" , for: .normal)
            
            
        case .Finish:
            centerPin.isHidden = true
            greenButton.setTitle("سرویس درخواست شد", for: .normal)
            greenButton.isEnabled = false
        }
        
    }
    
    //MARK: - Map Show Route
    func showRout()
    {
        let sourceLocation = originLoc
        let destinationLocation = destLoc
        
        // 3.
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        // 4.
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        
        // 7.
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        // 8.
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            
            self.map.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.map.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        
        return renderer
    }
    
    
    //MARK: - Map Region Did Change
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        //print("Map drag ended", map.centerCoordinate.latitude, map.centerCoordinate.longitude)
        
        if !moving
        {
            getLocation()
        }
        
        moving = false
        
    }
    
    //MARK: - Show User Location Name
    func getLocation(_ coordinate:CLLocationCoordinate2D? = nil)
    {
        let loc:CLLocationCoordinate2D!
        if let coordinate = coordinate{
            loc = coordinate
        }
        else{
            loc = map.centerCoordinate
        }
        
        
        func f1(_ status:PostStatus, _ name:String?)
        {
            if check(status, name)
            {
                DispatchQueue.main.async() {
                    self.origin.text = name!
                }
            }

        }
        
        func f2(_ status:PostStatus, _ name:String?)
        {
            if check(status, name)
            {
                DispatchQueue.main.async() {
                    self.dest.text = name!
                }
            }

        }
        
        func check(_ status:PostStatus, _ name:String?)-> Bool
        {
            if name != nil, status == .Yes
            {
                return true
            }
            else
            {
                return false
            }
        }
        
        if status == .Origin
        {
            Requests.locationToName(coordinate: loc, oncomplete: f1)
            Requests.positionList(loc, positionList)
        }
        else if status == .Dest
        {
            Requests.locationToName(coordinate: loc, oncomplete: f2)
        }
    }
    
    func positionList(_ agancies:[Agancy],_ cars:[CarPos])
    {
        //print("positionList, positionList positionList positionList")
        DispatchQueue.main.async {
            
            self.map.removeAnnotations(self.agancyPins)
            self.agancyPins.removeAll()
            
            for agancy in agancies{
                
                if let lat = agancy.lat, let long = agancy.long
                {
                    var title = ""
                    var subtitle = ""
                    
                    if let name = agancy.name{
                        title = "آژانس " + name
                    }
                    
                    if let phone = agancy.phone{
                        var num = phone
                        num.toPersian()
                        subtitle = num
                    }
                    
                    if let manager = agancy.manager{
                        subtitle += "\n" + manager
                    }
                    
                    let pin = self.createPin(lat, long, "agency",title, subtitle, 40, 40).annotation!
                    self.agancyPins.append(pin)
                    self.map.addAnnotation(pin)
                }
                
            }
            
            self.map.removeAnnotations(self.carPins)
            self.carPins.removeAll()
            
            for car in cars{
                
                if let lat = car.lat, let long = car.long
                {
                    let pin = self.createPin(lat, long, "mapCar",nil, nil, 60, 60).annotation!
                    self.carPins.append(pin)
                    self.map.addAnnotation(pin)
                }
                
            }
            
        }
    }
    
    //MARK: - Map Region Will Change
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        //print("regionWillChangeAnimated")
        searching = false
        addressList.isHidden = true
    }
    
    
    //MARK: - TextFields Touch
    @IBAction func originTouched(_ sender: Any) {
        startSearch(origin)
    }
    
    @IBAction func destTouched(_ sender: Any) {
        startSearch(dest)
    }
    
    func startSearch(_ box:UITextField)
    {
        //print("startSearch")
        DispatchQueue.main.async() {
            box.text = ""
        }
        
        searching = true
        currentField = box
    }
    
    @IBAction func exitOrigin(_ sender: Any) {
        exitTextField()
    }
    
    @IBAction func exitDest(_ sender: Any) {
        exitTextField()
    }
    
    func exitTextField()
    {
        //print("exitTextField")
        hideAddressList()
        if !moving
        {
            searching = false
            currentField = nil
            getLocation()
        }
    }
    
    @IBAction func originChanged(_ sender: Any) {
        if searching && currentField == origin
        {
            //print("originChanged")
            Requests.stringToList(str: origin.text, onComplete: updateList)
        }
    }
    
    @IBAction func destChanged(_ sender: Any) {
        if searching && currentField == dest
        {
            Requests.stringToList(str: dest.text, onComplete: updateList)
        }
    }
    
    //MARK: - AutoComplete
    func updateList(_ status:PostStatus, _ list1:[String:String]?)
    {
        var list:[String:String]
        if let list1 = list1, status == .Yes
        {
            list = list1
        }
        else
        {
            return
        }
        
        if(list.count == 0)
        {
            //print(Requests.last ?? "")
            //print(Requests.last2 ?? "")
            return
        }
        
        
        DispatchQueue.main.async()
            {
                let items = self.addressList.subviews
                for item in items
                {
                    item.isHidden = true
                }
                
                self.ids = ["","","",""]
                
                var i:Int = 0
                for (id, name) in list
                {
                    if let item = items[i] as? UITextField
                    {
                        item.text = name
                        item.isHidden = false
                        self.addressList.isHidden = false
                        item.addTarget(self, action: #selector(self.selectAddress(sender:)), for: UIControlEvents.touchDown)
                    }
                    
                    self.ids?[i] = id
                    
                    i += 1
                    if i >= 4{return}
                }
        }
        
    }
    
    func selectAddress(sender:UITextField)
    {
        //print("touch", sender)
        moving = true
        
        currentField?.text = sender.text
        //sender.removeTarget(nil, action: nil, for: .allEvents)
        
        func setCenter(_ status:PostStatus, _ loc:CLLocationCoordinate2D?)
        {
            if let loc = loc , status == .Yes
            {
                centerMapOnLocation(coordinate: loc)
            }
            else
            {
                Alert("Error on selectAddress(): from idToLocation()")
            }
        }
        
        let i: Int? = addressList.subviews.index(of: sender)
        if let i = i
        {
            if let id = ids?[safe:i]
            {
                Requests.idToLocation(id, setCenter)
            }
            else
            {
                moving = false
            }
        }
        else
        {
            moving = false
        }
        
        
    }
    
    func hideAddressList()
    {
        //print("hideAddressList")
        addressList.isHidden = true
        for view in addressList.subviews
        {
            (view as? UITextField)?.removeTarget(nil, action: nil, for: .allEvents)
        }
        
    }
    
    //MARK: - Map Goto Custom Location
    func centerMapOnLocation(coordinate:CLLocationCoordinate2D)
    {
        let loc = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        centerMapOnLocation(loc)
    }
    
    
    func centerMapOnLocation(_ location:CLLocation)
    {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        DispatchQueue.main.async()
            {
                self.map.setRegion(coordinateRegion, animated: true)
        }
    }
    
    //MARK: - when Location Updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //locationManager.stopUpdatingLocation()
        
        currentLocation = locations[0]
        if gotomyPosition{
            gotomyPosition = false
            centerMapOnLocation(currentLocation)
            getLocation()
        }
        
        
        
        
        //map.removeAnnotations(map.annotations)
        
        //pinAnnotationView = createPin(location: currentLocation)
        //map.addAnnotation(pinAnnotationView.annotation!)
    }
    
    //MARK: - Create Pin
    func createPin(coordinate:CLLocationCoordinate2D, _ name:String?)-> MKPinAnnotationView
    {
        return createPin(coordinate.latitude, coordinate.longitude, name)
    }
    
    func createPin(location:CLLocation, _ name:String?)-> MKPinAnnotationView
    {
        return createPin(location.coordinate.latitude, location.coordinate.longitude, name)
    }
    
    func createPin(_ lat:Double, _ long:Double, _ name:String? = "mapCar",_ title:String? = nil, _ subTitle:String? = nil, _ width:Int? = nil, _ height:Int? = nil) -> MKPinAnnotationView
    {
        let pin:CLLocation = CLLocation(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long))
        
        pointAnnotation = CustomPointAnnotation()
        
        if let w = width
        {
            pointAnnotation.w = w
        }
        
        if let h = height
        {
            pointAnnotation.h = h
        }
        
        pointAnnotation.name = name
        pointAnnotation.coordinate = pin.coordinate
        
        if let title = title{
            pointAnnotation.title = title
        }
        
        if let subtitle = subTitle{
            pointAnnotation.subtitle = subtitle
        }
        //pointAnnotation.title = "POKéSTOP"
        //pointAnnotation.subtitle = "Pick up some Poké Balls"
        
        pinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: name)
        
        return pinAnnotationView
    }
    
    
    //MARK: - Custom Annotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var myPin : CustomPointAnnotation!
        
        if let pin = annotation as? CustomPointAnnotation
        {
            myPin = pin
        }
        else
        {
            return nil
        }
        
        let reuseIdentifier : String! = myPin.name
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.canShowCallout = true
            //print(1)
        } else {
            annotationView?.annotation = annotation
            annotationView?.canShowCallout = true
            //print(2)
        }
        
        
        if let newImage = Model.stringToImage(myPin.name, Double(myPin.w), Double(myPin.h))
        {
            annotationView?.image = newImage
        }
        //annotationView?.transform = CGAffineTransform(rotationAngle: CGFloat(arc4random_uniform(360)))
        annotationView?.centerOffset = CGPoint(x: 0, y: -15)
        
        
        let subtitleView = UILabel()
        subtitleView.font = subtitleView.font.withSize(12)
        subtitleView.numberOfLines = 0
        subtitleView.text = annotation.subtitle!
        let fontSize = subtitleView.font.pointSize;
        subtitleView.font = UIFont(name: "Sahel", size: fontSize)
        subtitleView.textAlignment = .left
        annotationView!.detailCalloutAccessoryView = subtitleView
        
        
        
        return annotationView
    }
    
    
    
    
    //MARK: - tap Buttons
    @IBAction func goUserLocation(_ sender: Any) {
        //locationManager.startUpdatingLocation()
        centerMapOnLocation(currentLocation)
        gotomyPosition = true
        map.showsTraffic = true
    }
    
    @IBAction func onGreenButton(_ sender: Any) {
        switch status {
        case .Origin:
            originLoc = self.map.centerCoordinate
            getLocation(originLoc)
            status = .Dest
            getLocation()
        case .Dest:
            destLoc = self.map.centerCoordinate
            getLocation(destLoc)
            status = .Price
            getLocation()
        case .Price:
            showPrice()
            status = .Service
        case .Service:
            self.inProgress = true
            Requests.mapRequest(origin.text ?? "", dest.text ?? "", originLoc, destLoc, serviceResponce)
            //hidePrice()
            //status = .Finish
        case .Finish:
            status = .Finish
        }
    }
    
    func serviceResponce(_ status:PostStatus, service:Service?)
    {
        self.inProgress = false
        
        func run(_ function:@escaping ()->(), _ delay:Double)
        {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute: function)
        }

        func func1()
        {
            print("func1")
            self.hidePrice()
            
            run(func2, 0.1)
        }
        
        func func2()
        {
            print("func2")
            self.status = .Finish
            
            run(func3, 0.1)
        }
        
        func func3()
        {
            print("func3")
            self.showDriver(service!)
        }
        
        func func4()
        {
            print("func4")
            self.Alert("Service Not Found", "ERROR", "OK")
        }
        
        
        
        if let service = service, status == .Yes
        {
            run(func1, 0.1)
            print(service.time, service.ID, service.driver.imgPath, service.driver.name, service.driver.phone, service.car.color, service.car.model, service.car.number)
        }
        else
        {
            run(func4, 0.1)
        }
        
        
        return
        
        if let service = service, status == .Yes
        {
            self.Alert("Service Found")
            self.hidePrice()
            self.status = .Finish
            
            self.showDriver(service)
            
            print(service.time, service.ID, service.driver.imgPath, service.driver.name, service.driver.phone, service.car.color, service.car.model, service.car.number)
        }
        else
        {
            self.Alert("Service Not Found", "ERROR", "OK")
        }
    }
    
    func showPrice()
    {
        
        if self.storyboard != nil && priceView == nil
        {
            if let vc = self.storyboard!.instantiateViewController(withIdentifier: "priceVc") as? PriceController
            {
                priceVC = vc
                
                if let View = vc.view
                {
                    priceView = View
                    
                    let w = View.bounds.width
                    let h = View.bounds.height
                    
                    View.bounds = CGRect(x:0, y:0, width:w, height:h*0.7)
                    View.clipsToBounds = true
                    View.isHidden = true
                    
                    self.view.addSubview(View)
                    
                    View.frame.origin.y = 0
                    
                    /*
                     if let v = View.subviews[0] as? UIView
                     {
                     v.frame = CGRect(x:0, y:0, width:w, height:h*0.7)
                     }
                     */
                    self.priceVC?.vc = self
                }
                
            }
        }
        
        if let View = priceView
        {
            inProgress = true
            
            self.priceVC?.load()
            
            
            View.alpha = 0
            View.isHidden = false
            
            UIView.animate(withDuration: 1.35, animations: {
                
                View.alpha = 1
                
            }, completion: {finished in
                
                //self.priceVC?.vc = self
                //self.waiting.stopAnimating()
                self.inProgress = false
            })
        }
        
        
        /*
         if self.storyboard != nil && priceView == nil
         {
         if let vc = self.storyboard!.instantiateViewController(withIdentifier: "priceVc") as? PriceController
         {
         priceVC = vc
         vc.modalPresentationStyle = .overCurrentContext
         vc.isModalInPopover = true
         vc.modalTransitionStyle = .crossDissolve
         
         self.present(vc, animated: true, completion: nil)
         }
         }
         else if let vc = priceVC{
         
         vc.view.isHidden = false
         }
         else if let vc = priceView
         {
         vc.isHidden = false
         }
         */
        
    }
    
    func showDriver(_ service:Service)
    {
        print("showDriver")
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "driverVc") as? DriverController
        vc?.modalPresentationStyle = .overCurrentContext
        vc?.service = service
        present(vc!, animated: true, completion: nil)
        
    }
    


    
    
    /*
     func showPrice()
     {
     if self.storyboard != nil && priceView == nil
     {
     if let vc = self.storyboard!.instantiateViewController(withIdentifier: "priceVc") as? PriceController
     {
     if let newView = vc.view
     {
     /*
     if let View = newView.subviews[0] as? UIView
     {
     self.priceView = View
     let bounds = self.textHolder.bounds
     let w = bounds.maxX - bounds.minX
     let h = bounds.maxY - bounds.minY
     
     View.frame = CGRect(x:0, y:0, width:w, height:h*2)
     View.frame.origin.x = self.textHolder.frame.origin.x
     View.frame.origin.y = self.textHolder.frame.origin.y
     
     }
     */
     
     if let v = newView.subviews[0] as? UIView
     {
     let x = v.layer.frame.minX
     let y = v.layer.frame.minY
     let w = v.layer.frame.maxX - x
     let h = v.layer.frame.maxY - y
     
     
     newView.bounds = CGRect(x: Double(x), y: Double(y), width: Double(w), height: Double(h))
     }
     
     newView.clipsToBounds = true
     self.priceView = newView
     
     }
     }
     //vc.modalPresentationStyle = .overFullScreen
     //vc.modalTransitionStyle = .crossDissolve
     //self.present(vc, animated: true, completion: nil)
     
     }
     
     if let newView = priceView{
     self.view.addSubview(newView)
     print(newView.bounds)
     }
     }
     */
    
    
    
    
    func hidePrice()
    {
        if let View = priceView
        {
            UIView.animate(withDuration: 0.35, animations: {
                
                View.alpha = 0
                
            }, completion: {finished in
                
                View.isHidden = true
            })
        }
    }
    
    func hideDriver()
    {
        if let View = driverView
        {
            UIView.animate(withDuration: 0.35, animations: {
                
                View.alpha = 0
                
            }, completion: {finished in
                
                View.isHidden = true
            })
        }
    }
    
    
    @IBAction func closeOrigin(_ sender: Any) {
        status = .Origin
        getLocation()
        dest.text = ""
    }
    
    @IBAction func closeDest(_ sender: Any) {
        status = .Dest
        getLocation()
    }
    
    
    /*
     override func loadView() {
     let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
     let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
     view = mapView
     
     let marker = GMSMarker()
     marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
     marker.title = "my Title"
     marker.snippet = "my Snippet"
     marker.map = mapView
     }
     */
    /*
     private func initLocationManager(){
     locationManager.delegate = self
     locationManager.desiredAccuracy = kCLLocationAccuracyBest
     locationManager.requestWhenInUseAuthorization()
     locationManager.startUpdatingLocation()
     }
     
     func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
     
     if let location = locationManager.location?.coordinate{
     userLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
     
     let coordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
     
     let region = MKCoordinateRegion(center: userLocation!, span: coordinateSpan)
     
     map.setRegion(region, animated: true)
     
     map.removeAnnotations(map.annotations)
     
     let annotation = MKPointAnnotation()
     annotation.coordinate = userLocation!
     annotation.title = "مکان شما"
     map.addAnnotation(annotation)
     }
     }
     
     */
}

class CustomPointAnnotation: MKPointAnnotation {
    var name:String! = "mapCar"
    var w:Int! = 60
    var h:Int! = 60
}

extension Collection where Indices.Iterator.Element == Index {
    
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
