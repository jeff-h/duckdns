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
    
    // MARK:- Properties
    
//    var userDefaults = NSUserDefaults.standardUserDefaults()
    var userNotifications = NSUserNotificationCenter.defaultUserNotificationCenter()
    var notificationCenter = NSNotificationCenter.defaultCenter()
    var statusItemPopup: AXStatusItemPopup?
    var myContentViewController: ContentViewController!
    
    
    // MARK:- NSApplicationDelegate methods
    
    func applicationDidFinishLaunching(aNotification: NSNotification?) {
        // init the content view controller which will be shown inside the
        // popover.
        myContentViewController = ContentViewController(nibName: "ContentViewController", bundle: NSBundle.mainBundle())
        
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
        notificationCenter.addObserver(
            self,
            selector: "reachabilityChanged:",
            name: kReachabilityChangedNotification,
            object: nil
        )
        reachability.startNotifier()

//        var welcomeWindow = WelcomeWindowViewController(windowNibName: "WelcomeWindowView")
//        welcomeWindow.showWindow(self)
//        println("just did showWindow")
//        println(welcomeWindow.window)
        
    }
    
    func applicationWillTerminate(aNotification: NSNotification?) {
        // Insert code here to tear down your application

        notificationCenter.removeObserver(self)
        
        DuckDNSModel.sharedInstance.saveModel()
    }

    
    // MARK:- Reachability and other delegate methods
    
    func reachabilityChanged(notification: NSNotification) {
        var reachability = notification.object as Reachability
        println("Reachability Changed")
        
        // If we've become reachable again, then update Duck.
        if (reachability.isReachable()) {
            println("Reachability available")
            DuckDNSModel.sharedInstance.fetchPublicIP()
        }
    }

    func userNotificationCenter(center: NSUserNotificationCenter!, shouldPresentNotification notification: NSUserNotification!) -> Bool {
        // Return false, as we don't want to present notifications if this app
        // is active.
        return false
    }
    
    
    // MARK:- Other functions
    
    func sendNotification(#title: String, body: String) {
        var notification = NSUserNotification()
        
        notification.title = title
        notification.informativeText = body;
        notification.soundName = NSUserNotificationDefaultSoundName
        
        userNotifications.deliverNotification(notification)
    }    
}

