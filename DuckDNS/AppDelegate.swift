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
    var notificationCenter = NSNotificationCenter.defaultCenter()
    var statusItemPopup: AXStatusItemPopup?
    var duckDNSModel: DuckDNSModel!
    
    func applicationDidFinishLaunching(aNotification: NSNotification?) {
        // Insert code here to initialize your application
        
        // Register some defaults for first-run.
        let defaults = [
            "lastKnownIP":"",
            "domain":"",
            "token": "",
            "updateSucceeded": false
        ]
        userDefaults.registerDefaults(defaults)
                
        // Init the models.
        self.duckDNSModel = DuckDNSModel()
        
        // init the content view controller
        // which will be shown inside the popover.
        let myContentViewController = ContentViewController(nibName: "ContentViewController", bundle: NSBundle.mainBundle(), duckDNSModel: self.duckDNSModel)
        
        // On every app first run, update Duck DNS.
        self.duckDNSModel.setCurrentIP()
        
        // Initialise the status item popup.
        let image = NSImage(named: "cloud")
        let alternateImage = NSImage(named: "cloudgrey")

        self.statusItemPopup = AXStatusItemPopup(viewController: myContentViewController, image: image, alternateImage: alternateImage);

        // Give the contentview a reference to the popover to e.g. hide it from
        // there.
        myContentViewController.statusItemPopup = self.statusItemPopup;
        
        // Set self as the user notifications centre delegate.
        userNotifications.delegate = self
        
        var reachability = Reachability(hostName: "www.google.com")
        reachability.startNotifier()

        // Start watching Reachability now that it's started above, to avoid
        // being notified when it first sees us online.
        notificationCenter.addObserver(
            self,
            selector: "reachabilityChanged:",
            name: kReachabilityChangedNotification,
            object: nil
        )
        
//        var welcomeWindow = WelcomeWindowViewController(windowNibName: "WelcomeWindowView")
//        welcomeWindow.showWindow(self)
//        println("just did showWindow")
//        println(welcomeWindow.window)
        
    }
    
    func reachabilityChanged(notification: NSNotification) {
        var reachability: Reachability = notification.object as Reachability
        if (reachability.isReachable()) {
            self.duckDNSModel.setCurrentIP()
        }
    }

    func applicationWillTerminate(aNotification: NSNotification?) {
        // Insert code here to tear down your application
        notificationCenter.removeObserver(self)
    }

    func userNotificationCenter(center: NSUserNotificationCenter!, shouldPresentNotification notification: NSUserNotification!) -> Bool {
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

