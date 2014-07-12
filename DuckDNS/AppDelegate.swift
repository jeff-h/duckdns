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
        
        // init the content view controller
        // which will be shown inside the popover.
        var myContentViewController = ContentViewController(nibName: "ContentViewController", bundle: NSBundle.mainBundle())
        
        // init the status item popup
        var image = NSImage(named: "cloud")
        var alternateImage = NSImage(named: "cloudgrey")

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

