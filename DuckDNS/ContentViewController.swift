//
//  ContentViewController.swift
//  DuckDNS
//
//  Created by Jeff Hanbury on 12/07/2014.
//  Copyright (c) 2014 Marmaladesoul. All rights reserved.
//

import Foundation

class ContentViewController: NSViewController {
    let app = NSApplication.sharedApplication().delegate as AppDelegate
    
    var statusItemPopup: AXStatusItemPopup?
    var duckDNSModel: DuckDNSModel
    
    @IBOutlet var StatusLabel: NSTextField
    @IBOutlet var DomainTextField: NSTextField
    @IBOutlet var TokenTextField: NSTextField

    @IBAction func DomainTextFieldAction(sender: AnyObject) {
        // duckDNSModel.updateCredentials()
    }
    
    @IBAction func TokenTextFieldAction(sender: AnyObject) {
        // updateCredentials()
    }
    
    @IBAction func OKButtonClicked(sender: AnyObject) {
        statusItemPopup?.hidePopover()
    }
    
    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!, duckDNSModel: DuckDNSModel) {
        self.duckDNSModel = duckDNSModel
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        // Watch for changes to the defaults.
        let options : NSKeyValueObservingOptions = .New | .Old | .Initial | .Prior
        app.userDefaults.addObserver(self, forKeyPath: "success", options:options, context: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.updateLabel()
    }
    
    func updateLabel() {
        let lastSentIP = duckDNSModel.getLastSentIP()
        
        if !lastSentIP.isEmpty {
            println("this lastSentIP is: " + lastSentIP)
            StatusLabel.stringValue = "Set to " + lastSentIP + " on some date"
        }
    }
    
    override func observeValueForKeyPath(keyPath: String!,
        ofObject object: AnyObject!,
        change: [NSObject : AnyObject]!,
        context: UnsafePointer<()>) {

    
        println("CHANGE OBSERVED: \(change)")
    }


}