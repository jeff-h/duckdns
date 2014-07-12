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
                            
    @IBOutlet var window: NSWindow

    @IBOutlet var showPopupBtn: NSButton

    @IBAction func showPopupBtnAction(sender: NSButton) {
        println("Heyhey")
     //   [_statusItemPopup showPopoverAnimated:YES];

        
    }
    
    func applicationDidFinishLaunching(aNotification: NSNotification?) {
        // Insert code here to initialize your application
        
        statusItemPopup = AXStatusItemPopup();
    }

    func applicationWillTerminate(aNotification: NSNotification?) {
        // Insert code here to tear down your application
    }


}

