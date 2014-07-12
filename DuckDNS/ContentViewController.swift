//
//  ContentViewController.swift
//  DuckDNS
//
//  Created by Jeff Hanbury on 12/07/2014.
//  Copyright (c) 2014 Marmaladesoul. All rights reserved.
//

import Foundation

class ContentViewController: NSViewController {
    
    var statusItemPopup: AXStatusItemPopup
    
    @IBAction func CloseButtonAction(sender: AnyObject) {
        
        statusItemPopup.hidePopover()
    }
    
    init(myStatusItemPopup: AXStatusItemPopup) {
        statusItemPopup = myStatusItemPopup;
        super.init()
    }
}