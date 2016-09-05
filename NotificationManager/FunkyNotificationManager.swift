

//
//  FunkyNotificationManager.swift
//  NotificationManager
//
//  Created by Piyush Sharma on 9/2/16.
//  Copyright © 2016 Piyush Sharma. All rights reserved.
//

import Foundation

enum DataType {
    case AsString(value: String)
    case AsAnyObject(value: AnyObject)
    case AsClosure(block: () -> Void)
    
    var value: Any {
        switch self {
        case .AsString(let value):
            return value
        case .AsAnyObject(let value):
            return value
        case .AsClosure(let block):
            return block
        }
    }
}

class FunkyNotificationManager  {
    
    private static var privateInstance: FunkyNotificationManager?
    
    //Same notification name will hold an array of observers(a dictionary)
    private var allObservers =  [String : [[String : DataType]]]()
    
    static var sharedInstance: FunkyNotificationManager? {
        
        guard let sharedPrivateInstance = self.privateInstance else {
            privateInstance = FunkyNotificationManager()
            return privateInstance
        }
        
        return sharedPrivateInstance
    }
    
    private init() {}
    
    func addNotificationObserver(name name: String?, observer: AnyObject?, block: () -> Void)  {
        let notificationName = DataType.AsString(value: name!).value as? String
        let observerDict: [String : DataType] = ["observer" : DataType.AsAnyObject(value: observer!), "block" : DataType.AsClosure(block: block)]
        
        //If notification name already exists in the dictionary, then
        if let _ = allObservers[name!] {
            
            //Append new observer for that notification name
            var observersArray: [[String : DataType]] = allObservers[name!]!
            observersArray.append(observerDict)
            
            //Update notification name's observers array
            allObservers = [notificationName! : observersArray]
        }
        else {
            //If notification name doesn't exist then add it as new entry of observer
            allObservers = [notificationName! : [observerDict]]
        }
    }

    func postNotification(name: String?) {
        
        //Check if notification name exist in dictionary
        if let _ = allObservers[name!] {
            
            //Check if observers array count > 0 for that notificatoin name
            if let observersArray = allObservers[name!] where observersArray.count > 0 {
                
                //Post notifications to all items for that name
                for observer in observersArray {
                    let handler = observer["block"]?.value as? (() -> Void)
                    handler!()
                }
            }
            else {
                //If observers array count == 1 for that notificatoin name
                let observerDict = allObservers[name!]![0]
                let handler = observerDict["block"]?.value as? (() -> Void)
                handler!()
            }
        }
    }
    
    func remove(name: String?, observer: AnyObject?) {
        
<<<<<<< HEAD
        //Check if notification name exist in dictionary
        if let _ = allObservers[name!] {
            
            //Check if notification name as key contains more than one observers
            if let observersArray = allObservers[name!] where observersArray.count > 0 {
                
                var currentObservers = allObservers[name!] // get all observers array
                for (index, observerDict) in observersArray.enumerate() {
                    
                    //Get current observer dictioanry value and compare
                    let currentObserver = observerDict["observer"]?.value as? AnyObject
                    if currentObserver === observer {
                        currentObservers?.removeAtIndex(index)
                    }
                }
                
                //Update observer dictionary with observers list
                allObservers = [name! : currentObservers!]
                
                //If no observer is exist in list then clear dictionary
                if currentObservers?.count == 0 {
                    allObservers.removeAll()
                }
            }
            //Dictionary notification name as key contains only one observer
            else {
                allObservers.removeValueForKey(name!)
            }
=======
        if allObservers.count == 0 {
            return
        }
        
        for (index, observerDict) in allObservers.enumerate() where (observerDict["observer"]!.value as? AnyObject) === observer! {
            allObservers.removeAtIndex(index)
        }
        
        if allObservers.count == 0 {
            print("No observer in the lists")
>>>>>>> 3f22e92c34231381ff59157139bf51f279774d47
        }
    }
    
    func destroy() {
        allObservers.removeAll()
    }
}
