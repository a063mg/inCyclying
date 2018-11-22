//
//  FullMapViewController.swift
//  inCyclying
//
//  Created by Alekseev Artem on 09.10.2018.
//  Copyright © 2018 Alekseev Artem. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class FullMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    let locationManager = CLLocationManager()
    
    var trip: [NSManagedObject] = []
    var locationList: [[CLLocation]] = [[]]
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    override func viewWillAppear(_ animated: Bool) {
        mapView.removeOverlays(mapView.overlays)
        locationList = [[]]
        
        StorageDataSource.getDefaults(){ (locationList,distance, seconds, calories,run, speedList, maxSpeed) in
            self.locationList = locationList
            print(run)
            if run == "load"{
                self.locationManager.stopUpdatingLocation()
            }
            else if run == "start"{
                self.locationManager.startUpdatingLocation()
            }
        }
        
        loadMap(locationList: locationList)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        mapView.delegate = self
        
        mapView.showsUserLocation = true
        mapView.removeOverlays(mapView.overlays)
        
    }
    
    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        if mode != .followWithHeading{
            segmentedController.selectedSegmentIndex = 0
        }
    }
    
    @IBAction func indexChanged(_ sender: Any) {
        switch segmentedController.selectedSegmentIndex
        {
        case 0:
            print(mapView.userTrackingMode == .followWithHeading)
        case 1:
            mapView.userTrackingMode = .followWithHeading
        case 2:
            if let userLocation = locationManager.location?.coordinate {
                let viewRegion = MKCoordinateRegionMakeWithDistance(userLocation, 1000, 1000)
                mapView.setRegion(viewRegion, animated: true)
            }
            else{
                segmentedController.selectedSegmentIndex = 0
            }
        case 3:
            showTrip(locationList: locationList)
        default:
            break
        }
    }
    
    func showTrip(locationList: [[CLLocation]]){
        
        var latitudes:[Double] = []
        locationList.map { $0.map { latitudes.append(Double($0.coordinate.latitude)) } }
        var longitudes:[Double] = []
        locationList.map { $0.map { longitudes.append(Double($0.coordinate.longitude)) } }

        if latitudes.count > 0 && longitudes.count > 0{
            let maxLat = latitudes.max()!
            let minLat = latitudes.min()!
            let maxLong = longitudes.max()!
            let minLong = longitudes.min()!
            let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2,
                                                longitude: (minLong + maxLong) / 2)
            let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.3,
                                        longitudeDelta: (maxLong - minLong) * 1.3)
            let region = MKCoordinateRegion(center: center, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func loadMap(locationList: [[CLLocation]]){
        
        for j in 0...locationList.count - 1{
            mapView.add(polyLine(Location: locationList[j]))
        }
        
    }
    
    func polyLine(Location: [CLLocation]) -> MKPolyline {
        
        var coords: [CLLocationCoordinate2D] = []
        
        coords = Location.map { location in
            
            return CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
        
        return MKPolyline(coordinates: coords, count: coords.count)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for newLocation in locations {
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }
            
            if let lastLocation = locationList.last!.last {
                let coordinates = [lastLocation.coordinate, newLocation.coordinate]
                mapView.add(MKPolyline(coordinates: coordinates, count: 2))
                
//                let region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 50000, 50000)
                //                mapView.setRegion(region, animated: true)
            }
            
            locationList[locationList.count - 1].append(newLocation)
            
            
        }
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .cyan
        renderer.lineWidth = 5
        return renderer
    }
}
