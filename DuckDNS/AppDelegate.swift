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
    var duckDNSModel: DuckDNSModel!
    var myContentViewController: ContentViewController!
    
    let modelDataPath: String = NSSearchPathForDirectoriesInDomains(.ApplicationSupportDirectory, .UserDomainMask, true)[0] as String + "/data.archive"
    
    
    // MARK:- NSApplicationDelegate methods
    
    func applicationDidFinishLaunching(aNotification: NSNotification?) {
        // Initialise the models.
        self.duckDNSModel = loadModel()
        
        // init the content view controller which will be shown inside the
        // popover.
        myContentViewController = ContentViewController(nibName: "ContentViewController", bundle: NSBundle.mainBundle(), duckDNSModel: self.duckDNSModel)
        
        // Update Duck DNS each time the app is opened.
        self.duckDNSModel.updateCheck()
        
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

        // Start watching Reachability now that it's started above. We do it in
        // this order in order to avoid being notified when reachability first
        //sees us online.
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
    
    func applicationWillTerminate(aNotification: NSNotification?) {
        // Insert code here to tear down your application

        notificationCenter.removeObserver(self)
        
        saveModel(duckDNSModel)
    }

    
    // MARK:- Reachability and other delegate methods
    
    func reachabilityChanged(notification: NSNotification) {
        var reachability = notification.object as Reachability
        println("Reachability Changed")
        println(reachability)
        
        // If we've become reachable again, then update Duck.
        if (reachability.isReachable()) {
            self.duckDNSModel.updateCheck()
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

    func loadModel() ->DuckDNSModel {
        var model = NSKeyedUnarchiver.unarchiveObjectWithFile(modelDataPath) as DuckDNSModel?
        
        if model == nil {
            model = DuckDNSModel()
        }
        
        return model!
    }
    
    func saveModel(duckDNSModel: DuckDNSModel) ->Bool {
        let success = NSKeyedArchiver.archiveRootObject(duckDNSModel, toFile: modelDataPath)
        
        return success
    }
    
}

