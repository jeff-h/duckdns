//
//  ContentViewController.swift
//  DuckDNS
//
//  Created by Jeff Hanbury on 12/07/2014.
//  Copyright (c) 2014 Marmaladesoul. All rights reserved.
//

import Foundation

class ContentViewController: NSViewController {
    
    var statusItemPopup: AXStatusItemPopup?
    
    @IBOutlet var StatusLabel: NSTextField
    @IBOutlet var SubdomainTextField: NSTextField
    @IBOutlet var TokenTextField: NSTextField
    
    @IBAction func SubdomainTextFieldAction(sender: AnyObject) {
        updateCredentials(["subdomain" : SubdomainTextField.stringValue])
    }
    
    @IBAction func TokenTextFieldAction(sender: AnyObject) {
        updateCredentials(["token" : TokenTextField.stringValue])
    }

    @IBAction func CloseButtonAction(sender: AnyObject) {
        statusItemPopup?.hidePopover()
    }
    
    func updateCredentials(credentials: [String : String]) {
        println(credentials)
    }
}