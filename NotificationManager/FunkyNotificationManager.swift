

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
    
    //Dictionary key as notification name will hold an array of observers(a dictionary)
    var allObservers = Dictionary<String, [[String : DataType]]>()
    
    static var sharedInstance: FunkyNotificationManager? {
        
        guard let sharedPrivateInstance = self.privateInstance else {
            privateInstance = FunkyNotificationManager()
            return privateInstance
        }
        
        return sharedPrivateInstance
    }
    
    private init() {}
    
    func addNotificationObserver(name name: String?, observer: AnyObject?, block: () -> Void)  {
        let observerDict: [String : DataType] = ["observer" : DataType.AsAnyObject(value: observer!), "block" : DataType.AsClosure(block: block)]
        
        //If notification name already exists in the dictionary, then
        if let _ = allObservers[name!] {
            
            //Append new observer for that notification name
            var observersArray: [[String : DataType]] = allObservers[name!]!
            observersArray.append(observerDict)
            
            //Update notification name's observers array
            allObservers.updateValue(observersArray, forKey: name!)
        }
        else {
            //If notification name doesn't exist then add it as new entry of observers
            allObservers.updateValue([observerDict], forKey: name!)
        }
    }

    func postNotification(name: String?) {
        
        //Check if notification name exist in dictionary
        if let _ = allObservers[name!] {
            
            //Check if observers array count > 0 for that notificatoin name
            if let observersArray = allObservers[name!] where observersArray.count > 1 {
                
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
                allObservers.updateValue(currentObservers!, forKey: name!)
                
                //If no observer is exist in list then clear dictionary
                if currentObservers?.count == 0 {
                    print("All observers removed")
                    allObservers.removeAll()
                }
            }
            //Dictionary notification name as key contains only one observer
            else {
                allObservers.removeValueForKey(name!)
            }
        }
    }
    
    func destroy() {
        allObservers.removeAll()
    }
}
