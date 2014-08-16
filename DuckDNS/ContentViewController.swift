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

    var statusItemPopup: AXStatusItemPopup!
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
        statusItemPopup.hidePopover()
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!, duckDNSModel: DuckDNSModel) {
        self.duckDNSModel = duckDNSModel
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()

        // Watch for changes to the "updateSucceeded" default.
        let options : NSKeyValueObservingOptions = .New | .Old
        app.userDefaults.addObserver(self, forKeyPath: "updateSucceeded", options:options, context: nil)

        println("came into viewDidAppear")
        self.updateLabel(alsoNotify: false)
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        
        app.userDefaults.removeObserver(self, forKeyPath: "updateSucceeded")
    }
    
    // The value for updateSucceeded was changed, most likely by the DuckDNS
    // model.
    override func observeValueForKeyPath(
        keyPath: String!,
        ofObject object: AnyObject!,
        change: [NSObject : AnyObject]!,
        context: UnsafeMutablePointer<()>) {
    
        println("came into observeValueForKeyPath")
        println(keyPath)
        println(change)
        self.updateLabel(alsoNotify: true);
    }

    func updateLabel(#alsoNotify: Bool) {
        let success     = duckDNSModel.getSuccess()
        let lastKnownIP = duckDNSModel.getLastKnownIP()
        var msg: String
        
        if success {
            msg = "Successfully synchronised with DuckDNS. Your public IP is now " + lastKnownIP
        }
        else {
            msg = "Syncronisation failed. Please check your domain and token."
        }
        
        self.StatusLabel!.stringValue = msg
        
        if (alsoNotify) {
            app.sendNotification(title: "Duck DNS", body: msg)
        }
    }
}