

//
//  FunkyNotificationManager.swift
//  NotificationManager
//
//  Created by Piyush Sharma on 9/2/16.
//  Copyright © 2016 Piyush Sharma. All rights reserved.


import Foundation

enum DataType {
    
    case AsString(value: String)
    case AsAnyObject(value: AnyObject)
    case AsClosure(block: () -> Void)
    case AsSelector(Selector)
    
    var value: Any {
        switch self {
        case .AsString(let value):
            return value
        case .AsAnyObject(let value):
            return value
        case .AsClosure(let block):
            return block
        case .AsSelector(let selector):
            return selector
        }
    }
}

class FunkyNotificationManager {
    
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
    
    private func addObserver(name: String?, observer: AnyObject?, observerDict: [String : DataType]) {
        
        //If notification name already exists in the dictionary, then
        if let existingObserversArray = allObservers[name!] {
           
            //Hold observers in temp array
            var tempObserversArray = existingObserversArray
            
            //Append new observer dictionary
            tempObserversArray.append(observerDict)
            
            //Update notification name's observers array
            allObservers.updateValue(tempObserversArray, forKey: name!)
        }
        else {
            //If notification name doesn't exist then add it as new entry of observers
            allObservers.updateValue([observerDict], forKey: name!)
        }
    }
    
    //Using Block
    func addNotificationObserver(name name: String?, observer: AnyObject?, block: () -> Void)  {
        let observerDict: [String : DataType] = ["observer" : DataType.AsAnyObject(value: observer!), "block" : DataType.AsClosure(block: block)]
        self.addObserver(name!, observer: observer!, observerDict: observerDict)
    }
    
    //Using Selector
    func addNotificationObserver(name name: String?, observer: AnyObject?, selector: Selector)  {
        let observerDict: [String : DataType] = ["observer" : DataType.AsAnyObject(value: observer!), "selector" : DataType.AsSelector(selector)]
        self.addObserver(name!, observer: observer!, observerDict: observerDict)
    }
    
    func postNotification(name: String?) {
        
        //Check if notification name exist in dictionary
        if let _ = allObservers[name!] {
            
            //Check if observers array count > 1 for that notificatoin name
            if let observersArray = allObservers[name!] where observersArray.count > 1 {
                
                //Post notifications to all items for that name
                for observerDict in observersArray {
                    if let handler = observerDict["block"]?.value as? (() -> Void) {
                        handler()
                    }
                    else if let selector = observerDict["selector"]?.value as? Selector {
                        let observer = observerDict["observer"]?.value as? AnyObject
                        NSTimer.scheduledTimerWithTimeInterval(0, target: observer!, selector: selector, userInfo: nil, repeats: false)
                    }
                }
            }
            else {
                
                //If observers array count == 1 for that notificatoin name
                let observerDict = allObservers[name!]![0]
                if let handler = observerDict["block"]?.value as? (() -> Void) {
                    handler()
                }
                else if let selector = observerDict["selector"]?.value as? Selector {
                    let observer = observerDict["observer"]?.value as? AnyObject
                    NSTimer.scheduledTimerWithTimeInterval(0, target: observer!, selector: selector, userInfo: nil, repeats: false)
                }
            }
        }
    }
    
    func remove(name: String?, observer: AnyObject?) {
        
        if allObservers.keys.count == 0 {
            return
        }
        
        if let observersArr = allObservers[name!] where observersArr.count > 1 {
            
            var tempObservers = observersArr
            for (index, currentObserverDict) in observersArr.enumerate() {
                if currentObserverDict["observer"]!.value as? AnyObject === observer! {
                    tempObservers.removeAtIndex(index)
                    allObservers.updateValue(tempObservers, forKey: name!)
                }
            }
        }
        else {
            if let currentObserverDict: [String : DataType] = allObservers[name!]?[0] {
                if (currentObserverDict["observer"]!.value as? AnyObject)  === observer! {
                    allObservers.removeValueForKey(name!)
                }
            }
        }
        
        if allObservers.keys.count == 0 {
            print("All observers removed")
        }
    }
    
    func destroy() {
        allObservers.removeAll()
    }
}
