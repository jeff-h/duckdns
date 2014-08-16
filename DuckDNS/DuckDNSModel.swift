//
//  DuckDNSModel.swift
//  DuckDNS
//
//  Created by Jeff Hanbury on 13/07/2014.
//  Copyright (c) 2014 Marmaladesoul. All rights reserved.
//

import Foundation

class DuckDNSModel: NSObject {
    let app = NSApplication.sharedApplication().delegate as AppDelegate
    
    override init() {
        super.init()
        
        // Watch for changes to specific defaults.
        let options : NSKeyValueObservingOptions = .New | .Old
        
        app.userDefaults.addObserver(self, forKeyPath: "domain", options: options, context: nil)
        app.userDefaults.addObserver(self, forKeyPath: "token",  options: options, context: nil)
        app.userDefaults.addObserver(self, forKeyPath: "lastKnownIP",  options: options, context: nil)
    }
    
    deinit {
        println("here deinit")
        app.userDefaults.removeObserver(self, forKeyPath: "domain")
        app.userDefaults.removeObserver(self, forKeyPath: "token")
        app.userDefaults.removeObserver(self, forKeyPath: "lastKnownIP")
    }
    
    // We'll be notified whenever NSUserDefault's domain, token or lastKnownIP
    // values changed.
    override func observeValueForKeyPath(
        keyPath: String!,
        ofObject object: AnyObject!,
        change: [NSObject : AnyObject]!,
        context: UnsafeMutablePointer<()>) {
        
        if (keyPath == "lastKnownIP") {
            println("observed val change in lastKnownIP")
            println(change)
            self.sendIPChange()
        }
        else {
            let domain = app.userDefaults.stringForKey("domain")
            let token  = app.userDefaults.stringForKey("token")
            
            if (!(domain.isEmpty || token.isEmpty)) {
                // Which will in turn trigger a Duck DNS update if the IP changes
                // from the last known value.
                self.setCurrentIP()
                //self.sendIPChange()
            }
            else {
                self.setSuccess(false) // One of the values is empty.
            }
        }
    }
    
    func setSuccess(success: Bool) {
        println("Set updateSucceeded to \(success)")
        self.app.userDefaults.setValue(success, forKey: "updateSucceeded")
    }
    
    func getSuccess()->Bool {
        return app.userDefaults.boolForKey("updateSucceeded")
    }
    
    func sendIPChange() {
        println("pinging Duck DNS")
        
        let domain = app.userDefaults.stringForKey("domain")
        let token  = app.userDefaults.stringForKey("token")
        let url = NSURL(string: "https://www.duckdns.org/update?domains=" + domain + "&token=" + token + "&ip=")

        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
            let resultString = (NSString(data: data, encoding: NSUTF8StringEncoding))
            let success = (resultString == "OK")
            self.setSuccess(success)
        }
        task.resume()
    }
    
    func getLastKnownIP() -> String {
        return app.userDefaults.stringForKey("lastKnownIP")
    }

    // Get the public IP, and save it to user defaults. If it's changed,
    // user defaults will trigger a change event.
    func setCurrentIP() {
        // Fetch public IP from http://echoip.net
        let url = NSURL(string: "http://echoip.net")
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
            let resultString = (NSString(data: data, encoding: NSUTF8StringEncoding))
            self.app.userDefaults.setValue(resultString, forKey: "lastKnownIP")
        }
        task.resume()
    }

}