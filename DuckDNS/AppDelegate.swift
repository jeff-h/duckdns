//
//  AppDelegate.swift
//  DuckDNS
//
//  Created by Jeff Hanbury on 12/07/2014.
//  Copyright (c) 2014 Marmaladesoul. All rights reserved.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    
    var statusItemPopup: AXStatusItemPopup?
    
    func applicationDidFinishLaunching(aNotification: NSNotification?) {
        // Insert code here to initialize your application
        
        // Init the model.
        let myCredentialsModel = CredentialsModel()
        
        // init the content view controller
        // which will be shown inside the popover.
        let myContentViewController = ContentViewController(nibName: "ContentViewController", bundle: NSBundle.mainBundle(), creds: myCredentialsModel)
        
        myContentViewController.creds = myCredentialsModel
        
        //https://www.duckdns.org/update?domains=dev1mmls&token=b98212c1-6a87-4f8f-82b0-a08c6ec27d4a&ip=
        
        // init the status item popup
        let image = NSImage(named: "cloud")
        let alternateImage = NSImage(named: "cloudgrey")

        statusItemPopup = AXStatusItemPopup(viewController: myContentViewController, image: image, alternateImage: alternateImage);

        // Set the popover to the contentview to e.g. hide it from there.
        myContentViewController.statusItemPopup = statusItemPopup;
        
        // Show the popup, nicely animated.
        statusItemPopup?.showPopoverAnimated(true)
    }

    func applicationWillTerminate(aNotification: NSNotification?) {
        // Insert code here to tear down your application
    }


}

