//
//  ContentViewController.swift
//  DuckDNS
//
//  Created by Jeff Hanbury on 12/07/2014.
//  Copyright (c) 2014 Marmaladesoul. All rights reserved.
//

import Foundation

class ContentViewController: NSViewController {
    
    // MARK:- Properties
    
    var statusItemPopup: AXStatusItemPopup!
//    var duckDNSModel: DuckDNSModel
    
    var jeff: String = "klj"
    
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
    
    
    // MARK:- Initialisation
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!, duckDNSModel: DuckDNSModel) {
//        self.duckDNSModel = duckDNSModel
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    
    // MARK:- Delegate functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()

        // Watch for changes to the "updateSucceeded" default.
        let options : NSKeyValueObservingOptions = .New | .Old
//        app.userDefaults.addObserver(self, forKeyPath: "updateSucceeded", options:options, context: nil)

        println("came into viewDidAppear")
//        self.updateLabel(alsoNotify: false)
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
    }
    
    // The value for updateSucceeded was changed, most likely by the DuckDNS
    // model.
//    override func observeValueForKeyPath(
//        keyPath: String!,
//        ofObject object: AnyObject!,
//        change: [NSObject : AnyObject]!,
//        context: UnsafeMutablePointer<()>) {
//    
//        println("came into observeValueForKeyPath")
//        println(keyPath)
//        println(change)
//        self.updateLabel(alsoNotify: true);
//    }
    
    func successChanged(success: Bool, duckDNSModel: DuckDNSModel) {
        updateLabel(duckDNSModel, alsoNotify: true)
    }

    func updateLabel(duckDNSModel: DuckDNSModel, alsoNotify: Bool) {
        var msg: String
        
        if duckDNSModel.success {
            msg = "Successfully synchronised with DuckDNS. Your public IP is now " + duckDNSModel.lastKnownIP
        }
        else {
            msg = "Syncronisation failed. Please check your domain and token."
        }
        
        self.StatusLabel!.stringValue = msg
        
        if (alsoNotify) {
// @todo            NSApplication.sharedApplication().sendNotification(title: "Duck DNS", body: msg)
        }
    }
}