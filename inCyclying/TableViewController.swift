//
//  TableViewController.swift
//  inCyclying
//
//  Created by Alekseev Artem on 09.10.2018.
//  Copyright © 2018 Alekseev Artem. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class TableViewController: UIViewController, UITableViewDataSource{
    
    var locations: [[CLLocation]] = [[]]
    var distance: Double = 0.0
    var time: String = "00.00.00"
    var date: Date = Date()
    var averageSpeed: Double = 0.0
    var rows: Int = 0
    var locationList: [[[CLLocation]]] = []
    var dateList: [Date] = []
    var secondsList: [Int] = []
    var distanceList: [Double] = []
    var averageSpeedList: [Double] = []
    var listOfSpeedList: [[Double]] = [[]]
    var caloriesList: [Int] = []
    var nameList: [String] = []
    var maxSpeed: Double = 0.0
    var maxSpeedList: [Double] = []
    var speedList: [Double] = []

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func clearAll(_ sender: Any) {
        StorageDataSource.deleteAllRecords()
        refresh()
    }
    
    func refresh(){
        
        locationList = []
        distanceList = []
        secondsList = []
        dateList = []
        averageSpeedList = []
        caloriesList = []
        nameList = []

        StorageDataSource.getAllTrips(){ (locationList, distanceList, secondsList, dateList, averageSpeedList, caloriesList, nameList, rows, listOfSpeedList, maxSpeedList) in
            self.locationList = locationList
            self.distanceList = distanceList
            self.secondsList = secondsList
            self.dateList = dateList
            self.averageSpeedList = averageSpeedList
            self.caloriesList = caloriesList
            self.nameList = nameList
            self.rows = rows
            self.maxSpeedList = maxSpeedList
            self.listOfSpeedList = listOfSpeedList
        }
        self.tableView.dataSource = self
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refresh()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Trip-cell", for: indexPath) as! CellTableView
        
        if indexPath.row < rows {
            
            let formatter = DateComponentsFormatter()
            if secondsList[indexPath.row] >= 3600{
                formatter.allowedUnits = [.hour, .minute, .second]
            }
            else{
                formatter.allowedUnits = [.minute, .second]
            }
            formatter.unitsStyle = .positional
            formatter.zeroFormattingBehavior = .pad
            
            cell.Title.text = String(formatter.string(from: TimeInterval(secondsList[indexPath.row]))!)
            cell.subTitle.text = String(distanceList[indexPath.row]) + " km"
            cell.name.text = nameList[indexPath.row]
            let formatterDate = DateFormatter()
            formatterDate.dateFormat = "dd.MM.yyyy"
            
            cell.date.text = formatterDate.string(from: dateList[indexPath.row])
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = tableView.indexPathForSelectedRow!
        if let _ = tableView.cellForRow(at: indexPath){
            self.performSegue(withIdentifier: "show-details", sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "show-details"{
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let destination =  segue.destination as! DetailedViewController
                
                let formatter = DateComponentsFormatter()
                if secondsList[indexPath.row] >= 3600{
                    formatter.allowedUnits = [.hour, .minute, .second]
                }
                else{
                    formatter.allowedUnits = [.minute, .second]
                }
                formatter.unitsStyle = .positional
                formatter.zeroFormattingBehavior = .pad
                
                destination.locationList = locationList[indexPath.row]
                destination.time = String(formatter.string(from: TimeInterval(secondsList[indexPath.row]))!)
                destination.seconds = secondsList[indexPath.row]
                destination.distance = distanceList[indexPath.row]
                destination.date = dateList[indexPath.row]
                destination.name = nameList[indexPath.row]
                destination.averageSpeed = averageSpeedList[indexPath.row]
                destination.calories = caloriesList[indexPath.row]
                destination.speedList = listOfSpeedList[indexPath.row]
                destination.maxSpeed = maxSpeedList[indexPath.row]
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows
    }
    
}
