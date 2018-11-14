//
//  ViewController.swift
//  inCyclying
//
//  Created by Alekseev Artem on 28.09.2018.
//  Copyright © 2018 Alekseev Artem. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class ViewController: UIViewController {
    
    var buttonTitle: String?
    var stopButtonColor: UIColor? = #colorLiteral(red: 0.8862745098, green: 0.02352941176, blue: 0.1725490196, alpha: 1)
    var stopButtonDarkColor: UIColor? = #colorLiteral(red: 0.7098039216, green: 0.01960784314, blue: 0.137254902, alpha: 1)
    var startButtonColor: UIColor? = #colorLiteral(red: 0.1960784314, green: 0.8039215686, blue: 0.1960784314, alpha: 1)
    var startButtonDarkColor: UIColor? = #colorLiteral(red: 0, green: 0.6078431373, blue: 0, alpha: 1)
    var doneButtonColor: UIColor? = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
    var doneButtonDarkColor: UIColor? = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
    var buttonType: buttonTypeState = .finished
    
    enum Run{
        case start
        case stop
        case load
        case finish
    }
    
    var run: Run = .finish
    var deltaT: Double = 0.001
    var weight: Double = 64.7
    var seconds: Int = 0
    var distance: Double = 0.0
    var speed: Double = 0.0
    var calories: Double = 0
    var averageSpeed: Double = 0.0
    var maxSpeed: Double = 0.0
    var locationList: [[CLLocation]] = [[]]
    var speedList: [Double] = []
    var caloriesList: [Double] = []
    var location: [CLLocation] = []
    var timer: Timer?
    var timer2: Timer?
    var name: String = "New Trip"
    var date: Date = Date()
    var extr: Double = 0
    var last: CGFloat = 0
    
    let screenSize: CGRect = UIScreen.main.bounds
    let fontName = "SFProDisplay-Thin"
    let locationManager = LocationManager.shared
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var calorieLabel: UILabel!
    
    @IBOutlet weak var nameButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        StorageDataSource.getDefaults(){ (locationList,distance, seconds, calories,run, speedList) in
            //print(locationList,distance,seconds, calories,run)
            self.locationList = locationList
            self.distance = distance
            self.seconds = seconds
            self.calories = Double(calories)
            self.speedList = speedList
            if self.string2Run(run: run) == .load{
                self.updateButtons()
                self.loadMap(locations: locationList)
                self.distanceLabel.text  = String(distance)
                self.calorieLabel.text  = String(calories)
                
                let formatter = DateComponentsFormatter()
                if seconds >= 3600{
                    formatter.allowedUnits = [.hour, .minute, .second]
                }
                else{
                    formatter.allowedUnits = [.minute, .second]
                }
                formatter.unitsStyle = .positional
                formatter.zeroFormattingBehavior = .pad
                
                self.timeLabel.text = formatter.string(from: TimeInterval(seconds))!
                self.buttonType = .loaded
            }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.allowsBackgroundLocationUpdates = true
        
        mapView.showsUserLocation = true
        mapView.delegate = self
        locationManager.delegate = self
        mapView.isZoomEnabled = false;
        mapView.isScrollEnabled = false;
        mapView.isUserInteractionEnabled = false;

        if let userLocation = locationManager.location?.coordinate {
            let viewRegion = MKCoordinateRegionMakeWithDistance(userLocation, 2000, 2000)
            mapView.setRegion(viewRegion, animated: true)
        }
        
        StorageDataSource.getDefaults(){ (locationList,distance, seconds, calories,run,speedList) in
            //print(locationList,distance,seconds, calories,run)
            self.locationList = locationList
            self.distance = distance
            self.seconds = seconds
            self.calories = Double(calories)
            self.speedList = speedList
            if self.string2Run(run: run) != .load{
                self.run = .stop
                self.buttonType = .paused
            }
            else{
                self.buttonType = .loaded
            }
        }
        updateButtons()
        loadMap(locations: locationList)
        distanceLabel.text  = String(distance)
        calorieLabel.text  = String(calories)
        
        let formatter = DateComponentsFormatter()
        if seconds >= 3600{
            formatter.allowedUnits = [.hour, .minute, .second]
        }
        else{
            formatter.allowedUnits = [.minute, .second]
        }
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        
        timeLabel.text = formatter.string(from: TimeInterval(seconds))!
        
    }

    
    @IBAction func changeName(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Change the name", message: "Enter your trip name:", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: {
            alert -> Void in
                let fNameField = alertController.textFields![0] as UITextField
            
                if fNameField.text != ""{
                    self.name = fNameField.text!
                    self.nameButton.setTitle(fNameField.text!, for: .normal)
                    self.nameButton.titleLabel?.font =  UIFont(name: self.fontName, size: 20)
                } else {
                    let errorAlert = UIAlertController(title: "Error", message: "Please input the field", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {
                        alert -> Void in
                        self.present(alertController, animated: true, completion: nil)
                    }))
                    self.present(errorAlert, animated: true, completion: nil)
                }
        }))
        
        alertController.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = self.name
            textField.textAlignment = .center
        })
            
        self.present(alertController, animated: true, completion: nil)
    }
    
    func loadMap(locations: [[CLLocation]]){
        
        for j in 0...locations.count - 1{
            mapView.add(polyLine(Location: locations[j]))
        }
        
    }
    
    func polyLine(Location: [CLLocation]) -> MKPolyline {
        
        var coords: [CLLocationCoordinate2D] = []
        
        coords = Location.map { location in
            
            return CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
        
        return MKPolyline(coordinates: coords, count: coords.count)
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let center = CLLocationCoordinate2D(
            latitude: userLocation.coordinate.latitude,
            longitude: userLocation.coordinate.longitude)
        
        let width = 1000
        let height = 1000
        
        let region = MKCoordinateRegionMakeWithDistance(center, CLLocationDistance(width), CLLocationDistance(height))
        
        mapView.setRegion(region, animated: true)
    }
    
    func updateButtons(){
        
        for i in 1...5{
            if let viewWithTag = self.view.viewWithTag(i) {
                viewWithTag.removeFromSuperview()
            }
        }
        
        switch buttonType{
            case .started:
                self.view.addSubview(makeStopButton())
            case .paused:
                self.view.addSubview(makeSartButton())
                self.view.addSubview(makeDoneButton())
            case .finished:
                self.view.addSubview(makeBigSartButton())
            case .loaded:
                self.view.addSubview(makeBigDoneButton())
        }
    }
    
    func run2String(run: Run) -> String{
        switch run{
            case .start:
                return "start"
            case .stop:
                return "stop"
            case .load:
                return "stop"
            case .finish:
                return "stop"
        }
    }
    
    func string2Run(run: String) -> Run{
        switch run{
            case "start":
                return .start
            case "stop":
                return .stop
            case "load":
                return .load
            case "finish":
                return .finish
        default:
            return .finish
        }
    }
    
    func countCalories(weight: Double, speed: Double, time: Double) -> Double{
        return(weight * speed * time * 3)/400
    }
    
    func eachSecond(){
        if run == .start{
            seconds += 1
            averageSpeed = Double(round(100*3600*(distance/Double(seconds)))/100)
            calories = (weight * averageSpeed * Double(seconds/60) * 3.0)/400
            calorieLabel.text = String(format: "%.0f", calories)
            
            let formatter = DateComponentsFormatter()
            if seconds >= 3600{
                formatter.allowedUnits = [.hour, .minute, .second]
            }
            else{
                formatter.allowedUnits = [.minute, .second]
            }
            formatter.unitsStyle = .positional
            formatter.zeroFormattingBehavior = .pad
            timeLabel.text = formatter.string(from: TimeInterval(seconds))!
            saveData()
        }
    }
    
    func saveData(){
        StorageDataSource.setDefaults(locationList: locationList, run: run2String(run: run), seconds: seconds, distance: Double(round(100*distance)/100), calories: Int(calories), name: name, speedList: speedList)
    }
    
    func startLocationUpdates() {
//        locationManager.activityType = .fitness
//        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
    }
    
    func startRun() {
            run = .start
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                self.eachSecond()
            }
            timer2 = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
                self.eachDeltaSecond()
            }
        
            let data = Date()
            let formatter = DateFormatter()
        
            formatter.dateFormat = "dd.MM.yyyy"
        
            date = data
        
            locationList.append([])
            startLocationUpdates()
            saveData()
    }
    
//    func getMET(speed: Double)->Double{
//        let speedInMph = speed*0.621371
//
//        if (speedInMph >= 0 && speedInMph - 0.5 < 0) {
//            return 0
//        } else if (speedInMph - 0.5 > 0 && speedInMph - 1.0 < 0) {
//            return 1.8
//        } else if (speedInMph - 2.0 == 0) {
//            return 2.5
//        } else if (speedInMph - 2.0 > 0 && speedInMph - 2.7 <= 0) {
//            return 3.0
//        } else if (speedInMph - 2.8 > 0 && speedInMph - 3.3 <= 0) {
//            return 3.5
//        } else if (speedInMph - 3.4 > 0 && speedInMph - 3.5 <= 0) {
//            return 4.3
//        } else if (speedInMph - 3.5 > 0 && speedInMph - 4.0 <= 0){
//            return 5.0
//        } else if (speedInMph - 4.0 > 0 && speedInMph - 4.5 <= 0) {
//            return 7.0
//        } else if (speedInMph - 4.5 > 0 && speedInMph - 5.0 <= 0) {
//            return 8.3
//        } else if (speedInMph - 5.0 > 0 && speedInMph - 5.5 <= 0) {
//            return 9.8
//        } else if (speedInMph - 5.5 > 0 && speedInMph - 6.0 <= 0) {
//            return 10.9
//        } else if (speedInMph - 6.0 > 0 && speedInMph - 7.0 <= 0) {
//            return 12.1
//        } else if (speedInMph - 7.0 > 0 && speedInMph - 8.5 <= 0) {
//            return 12.9
//        } else if (speedInMph - 8.5 > 0 && speedInMph - 10.0 <= 0) {
//            return 13.5
//        } else if (speedInMph - 10 > 0 && speedInMph - 14.0 <= 0) {
//            return 14
//        }
//
//        return 0
//
//    }
    
    func eachDeltaSecond() {
        deltaT += 0.01
    }
    
    func stopRun(){
        run = .stop
        speedLabel.text = String(0.0)
        locationManager.stopUpdatingLocation()
        timer?.invalidate()
        timer2?.invalidate()
        saveData()
    }
    
    func endRun(){
        let alertController = UIAlertController(title: "End run?",
                                                message: "Do you wish to end your run?",
                                                preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Save", style: .default) { _ in
            StorageDataSource.saveTrip(locationList: self.locationList, averageSpeed: self.averageSpeed, seconds: self.seconds, distance: Double(round(100*self.distance)/100), calories: Int(self.calories), date: self.date, name: self.name)
            self.endrun()
        })
        alertController.addAction(UIAlertAction(title: "Discard", style: .destructive) { _ in
            self.endrun()
        })
        
        present(alertController, animated: true)
        
    }
    
    func endrun(){
        mapView.removeOverlays(mapView.overlays)
        speedLabel.text = "0,00"
        timeLabel.text = "0:00"
        distanceLabel.text = "0,00"
        calorieLabel.text = "0"
        seconds = 0
        distance = 0.0
        speed = 0.0
        averageSpeed = 0.0
        calories = 0
        name = "New Trip"
        locationList = [[]]
        speedList = []
        run = .finish
        buttonType = .finished
        updateButtons()
        saveData()
        StorageDataSource.clearDefaults()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}


extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        for newLocation in locations {
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }
            
            if let lastLocation = locationList.last!.last {
                let delta = newLocation.distance(from: lastLocation)
                distance = distance + delta/1000
                distanceLabel.text  =  String(format: "%.2f", Double(round(100*distance)/100))
                let coordinates = [lastLocation.coordinate, newLocation.coordinate]
                mapView.add(MKPolyline(coordinates: coordinates, count: 2))
                
                let region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 500, 500)
                mapView.setRegion(region, animated: true)
            }
//            newLocation.altitude

            locationList[locationList.count - 1].append(newLocation)
            
        }
        
        if locationManager.location != nil{
            speed = Double(locationManager.location!.speed)*3.6
            
            if locationManager.location!.speed < 1{
                speed = 0.0
            }
            
//            let MET = getMET(speed: speed)
            
//            calories += (weight * speed * deltaT/60 * 3)/400
            if speedList.count == 0{
                speedList = [0]
            }
            
            speedList.append(Double(round(10*speed)/10))
            
//            deltaT = 0
//            if speed != 0 {
                
//                if last > CGFloat(round(10*speed)/10){
//                    if extr == -1{
//                        speedList.append(CGFloat(round(10*speed)/10))
//                    }
//                    extr = 1
//                }
//                else{
//                    if extr == 1{
//                        speedList.append(CGFloat(round(10*speed)/10))
//                    }
//                    extr = -1
//                }
//                last = CGFloat(round(10*speed)/10)
//
//            }
    
            speedLabel.text = String(format:"%.2f", speed)
        }
    }
}

// MARK: - Map View Delegate

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .blue
        renderer.lineWidth = 3
        return renderer
    }
}

