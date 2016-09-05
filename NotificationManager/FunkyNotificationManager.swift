

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
    private var allObservers = [ [String : DataType]]()
    
    static var sharedInstance: FunkyNotificationManager? {
        
        guard let sharedPrivateInstance = self.privateInstance else {
            privateInstance = FunkyNotificationManager()
            return privateInstance
        }
        
        return sharedPrivateInstance
    }
    
    
    private init() {}
    
    func addNotificationObserver(name name: String?, observer: AnyObject?, block: () -> Void)  {
        let observer: [String : DataType] = ["name" : DataType.AsString(value: name!),"observer" : DataType.AsAnyObject(value: observer!), "block" : DataType.AsClosure(block: block)]
        allObservers.append(observer)
    }

    func postNotification(name: String?) {
        
        for observerDict: [String : DataType] in allObservers where (observerDict["name"]!.value as? String) == name! {
            let handler  = observerDict["block"]?.value as? (() -> Void)
            handler!()
        }
    }
    
    func remove(name: String?, observer: AnyObject?) {
        
        if allObservers.count == 0 {
            return
        }
        
        for (index, observerDict) in allObservers.enumerate() where (observerDict["observer"]!.value as? AnyObject) === observer! {
            allObservers.removeAtIndex(index)
        }
        
        if allObservers.count == 0 {
            print("No observer int the lists")
        }
    }
    
    func destroy() {
        allObservers.removeAll()
    }
}
