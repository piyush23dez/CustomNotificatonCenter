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
        FunkyNotificationManager.sharedInstance?.addNotificationObserver(name: "GenericNotification", observer: self, block: handleNotification)
    }
    
    var handleNotification: () -> Void  = { notification in
        print("Notification received in Person class")
    }
    
    func removeObserver() {
        FunkyNotificationManager.sharedInstance?.remove("GenericNotification", observer: self)
    }
}

class Car {
    
    lazy var funkyNotificationInstance = FunkyNotificationManager.sharedInstance!
    
    init() {
        FunkyNotificationManager.sharedInstance?.addNotificationObserver(name: "GenericNotification", observer: self, block: handleNotification)
    }
    
    var handleNotification: () -> Void  = { notification in
        print("Notification received in Car class")
    }
    
    func removeObserver() {
        FunkyNotificationManager.sharedInstance?.remove("GenericNotification", observer: self)
    }
}

