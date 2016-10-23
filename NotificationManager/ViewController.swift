//
//  ViewController.swift
//  NotificationManager
//
//  Created by Piyush Sharma on 9/2/16.
//  Copyright © 2016 Piyush Sharma. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    lazy var funkyNotificationInstance = FunkyNotificationManager.sharedInstance!
    let person = Person()
    let car = Car()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func post(sender: AnyObject) {        
        funkyNotificationInstance.postNotification("GenericNotification")
    }
    
    @IBAction func removeObservers() {
        car.removeObserver()
        person.removeObserver()
    }
}

class Person {
    
    lazy var funkyNotificationInstance = FunkyNotificationManager.sharedInstance!
    
    init() {
        //funkyNotificationInstance.addNotificationObserver(name: "GenericNotification", observer: self, block: handleNotification)
        funkyNotificationInstance.addNotificationObserver(name: "GenericNotification", observer: self, selector: Selector("handlePersonSelector"))
    }
    
    dynamic func handlePersonSelector() {
        print("Notification received in Person class using selector")
    }
    
    var handleNotification: () -> Void  = { notification in
        print("Notification received in Person class")
    }
    
    func removeObserver() {
        funkyNotificationInstance.remove("GenericNotification", observer: self)
    }
}

class Car {
    
    lazy var funkyNotificationInstance = FunkyNotificationManager.sharedInstance!
    
    init() {
        //funkyNotificationInstance.addNotificationObserver(name: "GenericNotification", observer: self, block: handleNotification)
        funkyNotificationInstance.addNotificationObserver(name: "GenericNotification", observer: self, selector: Selector("handleCarSelector"))
    }
    
    /* When you mark a member declaration with the dynamic modifier, 
       access to that member is always dynamically dispatched using the Objective-C runtime.*/
    dynamic func handleCarSelector() {
        print("Notification received in car class using selector")
    }
    
    var handleNotification: () -> Void  = { notification in
        print("Notification received in Car class")
    }
    
    func removeObserver() {
        funkyNotificationInstance.remove("GenericNotification", observer: self)
    }
}

