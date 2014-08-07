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
    
    @IBOutlet var DomainTextField: NSTextField!
    @IBOutlet var TokenTextField: NSTextField!
    @IBOutlet weak var StatusLabel: NSTextField?
    
    @IBAction func DomainTextFieldAction(sender: AnyObject) {
//        app.userDefaults.synchronize()
    }
    
    @IBAction func TokenTextFieldAction(sender: AnyObject) {
//        app.userDefaults.synchronize()
    }
    
    @IBAction func OKButtonClicked(sender: AnyObject) {
        statusItemPopup?.hidePopover()
    }
    
    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!, duckDNSModel: DuckDNSModel) {
        self.duckDNSModel = duckDNSModel
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Watch for changes to the "updateSucceeded" default.
        let options : NSKeyValueObservingOptions = .New | .Old
        app.userDefaults.addObserver(self, forKeyPath: "updateSucceeded", options:options, context: nil)

        self.updateLabel()
    }
    
    func updateLabel() {
        let success     = duckDNSModel.getSuccess()
        //let lastSentIP  = duckDNSModel.getLastSentIP()
        var msg: String
        
        if success {
            msg = "Successfully syncronised with DuckDNS."
        }
        else {
            msg = "Syncronisation failed. Please check your domain and token."
        }
        
        self.StatusLabel!.stringValue = msg
    }
    
    // The value for updateSucceeded was changed, most likely by the DuckDNS
    // model.
    override func observeValueForKeyPath(
        keyPath: String!,
        ofObject object: AnyObject!,
        change: [NSObject : AnyObject]!,
        context: UnsafePointer<()>) {
    
        var body: String
        
        self.updateLabel();
        
        if change["new"]?.boolValue == true {
            body = "Duck DNS was successfully updated."
        }
        else {
            body = "Duck DNS update failed."
        }
        
        app.sendNotification(title: "Duck DNS", body: body)
    }

}