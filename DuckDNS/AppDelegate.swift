//
//  AppDelegate.swift
//  DuckDNS
//
//  Created by Jeff Hanbury on 12/07/2014.
//  Copyright (c) 2014 Marmaladesoul. All rights reserved.
//

import Cocoa

class AppDelegate:  NSObject,
                    NSApplicationDelegate,
                    NSUserNotificationCenterDelegate {
    
    var userDefaults = NSUserDefaults.standardUserDefaults()
    var userNotifications = NSUserNotificationCenter.defaultUserNotificationCenter()
    
    var statusItemPopup: AXStatusItemPopup?
    
    func applicationDidFinishLaunching(aNotification: NSNotification?) {
        // Insert code here to initialize your application
        
        // Register some defaults for first-run.
        let defaults = [
            "lastSentIP":"",
            "domain":"",
            "token": "",
            "updateSucceeded": false
        ]
        userDefaults.registerDefaults(defaults)
                
        // Init the models.
        let duckDNSModel = DuckDNSModel()
        
        // init the content view controller
        // which will be shown inside the popover.
        let myContentViewController = ContentViewController(nibName: "ContentViewController", bundle: NSBundle.mainBundle(), duckDNSModel: duckDNSModel)
        
        // On every app first run, update Duck DNS.
        duckDNSModel.sendIPChange()
        
        // init the status item popup
        let image = NSImage(named: "cloud")
        let alternateImage = NSImage(named: "cloudgrey")

        statusItemPopup = AXStatusItemPopup(viewController: myContentViewController, image: image, alternateImage: alternateImage);

        // Give the contentview a reference to the popover to e.g. hide it from
        // there.
        myContentViewController.statusItemPopup = statusItemPopup;
        
        // Show the popup, nicely animated.
//        statusItemPopup?.showPopoverAnimated(true)
        
        // Set self as the user notifications centre delegate.
        userNotifications.delegate = self
        
        
    }

    func applicationWillTerminate(aNotification: NSNotification?) {
        // Insert code here to tear down your application
    }

    func userNotificationCenter(center: NSUserNotificationCenter!, shouldPresentNotification notification: NSUserNotification!) -> Bool {
        println("came into shouldPresentNotification")
        // Return false, as we don't want to present notifications if this app
        // is active.
        return false
    }
    
    func sendNotification(#title: String, body: String) {
        var notification = NSUserNotification()
        
        notification.title = title
        notification.informativeText = body;
        notification.soundName = NSUserNotificationDefaultSoundName
        
        userNotifications.deliverNotification(notification)
    }
}

