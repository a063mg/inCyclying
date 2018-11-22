//
//  DetailedViewController.swift
//  inCyclying
//
//  Created by Alekseev Artem on 09.10.2018.
//  Copyright © 2018 Alekseev Artem. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import Charts


class DetailedViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var startedLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rideTimeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var averageSpeedLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var lineChart: LineChartView!
    
    enum Run{
        case start
        case stop
        case load
        case finish
    }
    
    var run: Run = .finish
    var name: String = ""
    var distance:Double = 0.0
    var time: String = ""
    var seconds: Int = 0
    var date: Date = Date()
    var averageSpeed: Double = 0.0
    var calories: Int = 0
    var locationList:[[CLLocation]] = [[]]
    var speedList: [Double] = []
    var trip: [NSManagedObject] = []
    var avaliable: Bool = true
    var maxSpeed: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        
        
        startedLabel.text = formatter.string(from: date)
        nameLabel.text = name
        rideTimeLabel.text = String(time)
        distanceLabel.text = String(distance) + " km"
        averageSpeedLabel.text = String(averageSpeed) + " km/h"
        caloriesLabel.text = String(calories) + " cl"
        print(speedList)
        loadMap()
        setChart(values: speedList)
        
        showTrip(locationList: locationList)
        
    }
    
    func loadMap(){
        
        for j in 0...locationList.count - 1{
            mapView.add(polyLine(Location: locationList[j]))
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
    
    @IBAction func loadTrip(_ sender: Any) {
        StorageDataSource.getDefaults(){ (locationList,distance, seconds, calories,run,speedList,maxSpeed) in
                self.run = self.string2Run(run: run)
        }
        if run == .finish {
            StorageDataSource.setDefaults(locationList: locationList, run: "load", seconds: seconds, distance: Double(round(100*distance)/100), calories: Int(calories), name: name, speedList: speedList, maxSpeed: maxSpeed)
            showHomeController()
        }
        else{
            let errorAlert = UIAlertController(title: "Error", message: "You have got run in progress", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {
                alert -> Void in

            }))
            self.present(errorAlert, animated: true, completion: nil)
        }
    }
    
    @objc func showHomeController(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "tabBarController") as UIViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //show window
        appDelegate.window?.rootViewController = view
    }
    
    func setChart(values: [Double]) {
        lineChart.noDataText = "You need to provide data for the chart."
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<values.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: Double(values[i]))
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = LineChartDataSet(values: dataEntries, label: "Units Sold")
        chartDataSet.mode = .cubicBezier
        chartDataSet.cubicIntensity = 0.2
        chartDataSet.drawCirclesEnabled = false
        chartDataSet.colors = [UIColor.red]
        chartDataSet.lineWidth = 2
        let chartData = LineChartData(dataSet: chartDataSet)
        chartData.setDrawValues(false)
        
        let gradientColors = [UIColor.red.cgColor, UIColor.clear.cgColor] as CFArray
        let colorLocations: [CGFloat] = [1.0,0.0]
        guard let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations)
            else {
                print("gradient error.")
                return
        }
        
        chartDataSet.fill = Fill.fillWithLinearGradient(gradient, angle: 90)
        chartDataSet.drawFilledEnabled = true
        
        lineChart.data = chartData
        lineChart.backgroundColor = UIColor.white
        lineChart.doubleTapToZoomEnabled = false
        lineChart.highlightPerTapEnabled = false
        lineChart.leftAxis.axisMinimum = 0
        lineChart.highlightPerDragEnabled = false
        lineChart.xAxis.labelPosition = .bottom
        lineChart.xAxis.drawGridLinesEnabled = false
        lineChart.rightAxis.drawGridLinesEnabled = false
        lineChart.rightAxis.enabled = false
        lineChart.leftAxis.drawLabelsEnabled = true
        
    }
    
    func polyLine(Location: [CLLocation]) -> MKPolyline {
        
        var coords: [CLLocationCoordinate2D] = []
        
        coords = Location.map { location in
            print(location)
            return CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
        
        return MKPolyline(coordinates: coords, count: coords.count)
    }
    
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
