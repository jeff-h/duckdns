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
    
    init() {
        super.init()
        
        // Watch for changes to specific defaults.
        let options : NSKeyValueObservingOptions = .New | .Old | .Initial | .Prior
        app.userDefaults.addObserver(self, forKeyPath: "domain", options:options, context: nil)
        app.userDefaults.addObserver(self, forKeyPath: "token", options:options, context: nil)
    }
    
    func defaultsChanged(notification: NSNotification) {
        let userDefaults = notification.object as NSUserDefaults
        let domain = userDefaults.stringForKey("domain")
        let token  = userDefaults.stringForKey("token")

        if (!(domain.isEmpty || token.isEmpty)) {
            self.sendIPChange(domain: domain, token: token)
        }
    }
    
    override func observeValueForKeyPath(keyPath: String!,
        ofObject object: AnyObject!,
        change: [NSObject : AnyObject]!,
        context: UnsafePointer<()>) {
            
        let domain = app.userDefaults.stringForKey("domain")
        let token  = app.userDefaults.stringForKey("token")
        
        if (!(domain.isEmpty || token.isEmpty)) {
            self.sendIPChange(domain: domain, token: token)
        }
    }

    func sendToDuck(#domain: String, token: String) {
        println("SEND TO DUCK!")
        println(domain, token)
        
        self.sendIPChange(domain: domain, token: token)
    }
    
    func sendIPChange(#domain: String, token: String) {
        let url = NSURL(string: "https://www.duckdns.org/update?domains=" + domain + "&token=" + token + "&ip=")

        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
            let resultString = (NSString(data: data, encoding: NSUTF8StringEncoding))
            let success = (resultString == "OK")
            println("success was \(success)")
            //        // Store the last sent IP value.
            //        self.lastSentIP = self.userDefaults.stringForKey("lastSentIP")
            self.app.userDefaults.setValue(success, forKey: "succeeded")
        }
        task.resume()
    }
    
    func getLastSentIP() -> String {
        var lastSentIp: String = NSUserDefaults().stringForKey("lastSentIP")
        
        //        if lastSentIp == nil {
        //            lastSentIp = ""
        //        }
        
        return lastSentIp
    }

}