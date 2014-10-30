//
//  ContentViewController.swift
//  DuckDNS
//
//  Created by Jeff Hanbury on 12/07/2014.
//  Copyright (c) 2014 Marmaladesoul. All rights reserved.
//

import Foundation

class ContentViewController: NSViewController, DuckDNSModelDelegate {
    
    // MARK:- Properties
        
    var statusItemPopup: AXStatusItemPopup!
    
    @IBOutlet var DomainTextField: NSTextField!
    @IBOutlet var TokenTextField: NSTextField!
    @IBOutlet weak var StatusLabel: NSTextField?
    @IBOutlet var progressSpinner: NSProgressIndicator?
    
    @IBAction func DomainTextFieldAction(sender: AnyObject) {
//        app.userDefaults.synchronize()
    }
    
    @IBAction func TokenTextFieldAction(sender: AnyObject) {
//        app.userDefaults.synchronize()
    }
    
    @IBAction func OKButtonClicked(sender: AnyObject) {
        DuckDNSModel.sharedInstance.saveModel()
        statusItemPopup.hidePopover()        
    }
    
    var model: DuckDNSModel = DuckDNSModel.sharedInstance

    // MARK:- Initialisation
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override init?(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        println("init ran")
        
        DuckDNSModel.sharedInstance.delegate = self
    }
    
    
    // MARK:- Delegate functions
    
    override func viewDidLoad() {
        println("view did load")
        super.viewDidLoad()
    }
    
    override func viewDidAppear() {
        println("view did appear")
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
    
    func successChanged(success: Bool) {
        updateLabel(true)
    }

    func updateLabel(alsoNotify: Bool) {
        var msg: String
        
        if DuckDNSModel.sharedInstance.success {
            msg = "Successfully synchronised with DuckDNS. Your public IP is now " + DuckDNSModel.sharedInstance.lastKnownIP
        }
        else {
            msg = "Syncronisation failed. Please check your domain and token."
        }
        
        self.StatusLabel!.stringValue = msg
        
        if (alsoNotify) {
// @todo            NSApplication.sharedApplication().sendNotification(title: "Duck DNS", body: msg)
        }
    }
    
    
    // MARK: DuckDNSModelDelegate
    
    func willCheckExternalIP() {
        println("CAME HERE!!! willCheckExternalIP")
        progressSpinner?.hidden = false
        progressSpinner?.startAnimation(self)
        
        self.StatusLabel?.stringValue = "Checking external IP address."
    }

    func didCheckExternalIP(ip: String) {
        println("CAME HERE!!! DID CheckExternalIP: \(ip)")
        progressSpinner?.stopAnimation(self)
        progressSpinner?.hidden = true
        
        if ip != "" {
            self.StatusLabel?.stringValue = "External IP address is \(ip)"
        }
        else {
            self.StatusLabel?.stringValue = "External IP could not be determined"
        }
    }
    
    func willUpdateDuckDNS() {
        println("CAME HERE!!! willUpdateDuckDNS")
        progressSpinner?.startAnimation(self)
        progressSpinner?.hidden = false
        
        if self.StatusLabel != nil {
            self.StatusLabel!.stringValue = "Updating IP with Duck DNS"
        }
    }

    func didUpdateDuckDNS(success: Bool) {
        println("Finished DNS Update - Success was \(success)")
        progressSpinner?.stopAnimation(self)
        progressSpinner?.hidden = true
        
        let ip = DuckDNSModel.sharedInstance.lastKnownIP
        
        if success {
            var msgStr: String = "Duck DNS was successfully updated. Your external IP address is now \(ip)"
            
            self.StatusLabel?.stringValue = msgStr
            sendUserNotification(title: "Duck DNS", body: msgStr)
        }
        else {
            self.StatusLabel?.stringValue = "Duck DNS was not successfully updated. Please check you have entered the correct domain and token."
        }
    }
    
    
    
    // MARK: Helpers
 
    func sendUserNotification(#title: String, body: String) {
        var notification = NSUserNotification()
        
        notification.title = title
        notification.informativeText = body;
        notification.soundName = NSUserNotificationDefaultSoundName
        
        NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(notification)
    }
}