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
    
    class func getDefaults(completion: @escaping (([[CLLocation]], Double, Int, Int, String, [Double], Double) -> Swift.Void)){
        
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
        var maxSpeed: Double = 0.0
        
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
            maxSpeed = trip[0].value(forKey: "maxSpeed") as! Double

        }
        
        completion(locationList, distance, seconds, calories, run, speedList, maxSpeed)
    
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

    class func setDefaults(locationList: [[CLLocation]], run: String, seconds: Int, distance: Double, calories: Int, name: String, speedList: [Double], maxSpeed: Double){

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
        trip.setValue(maxSpeed, forKeyPath: "maxSpeed")
        

        do {
            try managedContext.save()

        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }

    }
    
    class func saveTrip(locationList: [[CLLocation]], averageSpeed: Double, seconds: Int, distance: Double, calories: Int, date: Date, name: String, speedList: [Double], maxSpeed: Double){
        
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
        
        trip.setValue(speedList, forKeyPath: "speedList")
        trip.setValue(locationList, forKeyPath: "locationList")
        trip.setValue(averageSpeed, forKeyPath: "averageSpeed")
        trip.setValue(seconds, forKeyPath: "time")
        trip.setValue(distance, forKeyPath: "distance")
        trip.setValue(calories, forKeyPath: "calories")
        trip.setValue(date, forKeyPath: "date")
        trip.setValue(name, forKeyPath: "name")
        trip.setValue(maxSpeed, forKeyPath: "maxSpeed")
        
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
    
    class func getAllTrips(completion: @escaping (([[[CLLocation]]], [Double], [Int], [Date], [Double], [Int], [String], Int, [[Double]], [Double]) -> Swift.Void)){
        
        var locationList: [[[CLLocation]]] = []
        var distanceList: [Double] = []
        var secondsList: [Int] = []
        var dateList: [Date] = []
        var averageSpeedList: [Double] = []
        var caloriesList: [Int] = []
        var nameList: [String] = []
        var speedList: [[Double]] = []
        var maxSpeedList: [Double] = []
        
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
                guard let locationListItem = trip[i].value(forKey: "locationList")
                    else {
                        print("nameList Error.")
                        return
                }
                
                locationList.append(locationListItem as! [[CLLocation]])
                
                guard let nameListItem = trip[i].value(forKey: "name")
                    else {
                        print("nameList Error.")
                        return
                }
                
                nameList.append(nameListItem as! String)
                
                guard let distanceListItem = trip[i].value(forKey: "distance")
                    else {
                        print("distanceList Error.")
                        return
                }
                
                distanceList.append(distanceListItem as! Double)
                
                guard let secondsListItem = trip[i].value(forKey: "time")
                    else {
                        print("secondsList Error.")
                        return
                }
                
                secondsList.append(secondsListItem as! Int)
                
                guard let dateListItem = trip[i].value(forKey: "date")
                    else {
                        print("dateList Error.")
                        return
                }
                
                dateList.append(dateListItem as! Date)
                
                guard let averageSpeedListItem = trip[i].value(forKey: "averageSpeed")
                    else {
                        print("averageSpeedList Error.")
                        return
                }
                
                averageSpeedList.append(averageSpeedListItem as! Double)
                
                guard let caloriesListItem = trip[i].value(forKey: "calories")
                    else {
                        print("caloriesList Error.")
                        return
                }
                
                caloriesList.append(caloriesListItem as! Int)
                
                guard let speedListItem = trip[i].value(forKey: "speedList")
                    else {
                        print("speedList Error.")
                        return
                }
                
                speedList.append(speedListItem as! [Double])
                
                guard let maxSpeedListItem = trip[i].value(forKey: "maxSpeed")
                    else {
                        print("maxSpeedList Error.")
                        return
                }
                
                maxSpeedList.append(maxSpeedListItem as! Double)
            }
        }
        
        completion(locationList, distanceList, secondsList, dateList, averageSpeedList, caloriesList, nameList, trip.count, speedList, maxSpeedList)
    }
    
}
