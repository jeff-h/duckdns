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
    var subdomain: String?
    var token: String?
    var creds: CredentialsModel?
    
    @IBOutlet var StatusLabel: NSTextField
    @IBOutlet var SubdomainTextField: NSTextField
    @IBOutlet var TokenTextField: NSTextField
    
    @IBAction func SubdomainTextFieldAction(sender: AnyObject) {
        updateCredentials("subdomain", value: SubdomainTextField.stringValue)
    }
    
    @IBAction func TokenTextFieldAction(sender: AnyObject) {
        updateCredentials("token", value: TokenTextField.stringValue)
    }
    
    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!, creds: CredentialsModel) {
        self.creds = creds
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    func updateCredentials(valueType: String, value: String) {
        println(valueType)
        println(value)
    }
}