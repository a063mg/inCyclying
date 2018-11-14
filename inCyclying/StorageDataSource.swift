//
//  StorageDataSource.swift
//  inCyclying
//
//  Created by Alekseev Artem on 30.09.2018.
//  Copyright © 2018 Alekseev Artem. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class StorageDataSource {
    
    class func getDefaults(completion: @escaping (([[CLLocation]], Double, Int, Int, String, [Double]) -> Swift.Void)){
        
        var trip: [NSManagedObject] = []
        
        enum Run{
            case start
            case stop
            case load
            case finish
            
        }
        
        var locationList: [[CLLocation]] = [[]]
        var speedList: [Double] = []
        var run: String = "finish"
        var distance: Double = 0.0
        var seconds: Int = 0
        var calories: Int = 0
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "CurrentTrip")
        
        do {
            trip = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        if trip.count > 0{
            
            locationList = trip[0].value(forKey: "locationList") as! [[CLLocation]]
            distance = trip[0].value(forKey: "distance") as! Double
            seconds = trip[0].value(forKey: "time") as! Int
            calories = trip[0].value(forKey: "calories") as! Int
            run = trip[0].value(forKey: "run") as! String
            speedList = trip[0].value(forKey: "speedList") as! [Double]

        }
        
        completion(locationList, distance, seconds, calories, run, speedList)
    
    }
    
    class func clearDefaults() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext

        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CurrentTrip")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }

    }

    class func setDefaults(locationList: [[CLLocation]], run: String, seconds: Int, distance: Double, calories: Int, name: String, speedList: [Double]){

        StorageDataSource.clearDefaults()

        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }

        let managedContext =
            appDelegate.persistentContainer.viewContext

        let entity = NSEntityDescription.entity(forEntityName: "CurrentTrip",
                                                in: managedContext)!

        let trip = NSManagedObject(entity: entity,
                                   insertInto: managedContext)

        trip.setValue(locationList, forKeyPath: "locationList")
        trip.setValue(run, forKeyPath: "run")
        trip.setValue(seconds, forKeyPath: "time")
        trip.setValue(distance, forKeyPath: "distance")
        trip.setValue(calories, forKeyPath: "calories")
        trip.setValue(name, forKeyPath: "name")
        trip.setValue(speedList, forKeyPath: "speedList")

        do {
            try managedContext.save()

        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }

    }
    
    class func saveTrip(locationList: [[CLLocation]], averageSpeed: Double, seconds: Int, distance: Double, calories: Int, date: Date, name: String){
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "AllTrips",
                                                in: managedContext)!
        
        let trip = NSManagedObject(entity: entity,
                                   insertInto: managedContext)
        
        trip.setValue(locationList, forKeyPath: "locationList")
        trip.setValue(averageSpeed, forKeyPath: "averageSpeed")
        trip.setValue(seconds, forKeyPath: "time")
        trip.setValue(distance, forKeyPath: "distance")
        trip.setValue(calories, forKeyPath: "calories")
        trip.setValue(date, forKeyPath: "date")
        trip.setValue(name, forKeyPath: "name")
        
        do {
            try managedContext.save()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    class func deleteAllRecords() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "AllTrips")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
    class func getAllTrips(completion: @escaping (([[[CLLocation]]], [Double], [Int], [Date], [Double], [Int], [String], Int) -> Swift.Void)){
        
        var locationList: [[[CLLocation]]] = []
        var distanceList: [Double] = []
        var secondsList: [Int] = []
        var dateList: [Date] = []
        var averageSpeedList: [Double] = []
        var caloriesList: [Int] = []
        var nameList: [String] = []
        
        var trip: [NSManagedObject] = []
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "AllTrips")
        
        do {
            trip = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        if trip.count != 0{
            for i in 0...trip.count-1{
                locationList.append(trip[i].value(forKey: "locationList") as! [[CLLocation]])
                nameList.append(trip[i].value(forKey: "name") as! String)
                distanceList.append(trip[i].value(forKey: "distance") as! Double)
                secondsList.append(trip[i].value(forKey: "time") as! Int)
                dateList.append(trip[i].value(forKey: "date") as! Date)
                averageSpeedList.append(trip[i].value(forKey: "averageSpeed") as! Double)
                caloriesList.append(trip[i].value(forKey: "calories") as! Int)
            }
        }
        completion(locationList, distanceList, secondsList, dateList, averageSpeedList, caloriesList, nameList, trip.count)
    }
    
}
