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
        let options : NSKeyValueObservingOptions = .New | .Old
        
        app.userDefaults.addObserver(self, forKeyPath: "domain", options: options, context: nil)
        app.userDefaults.addObserver(self, forKeyPath: "token",  options: options, context: nil)
    }
    
    // We'll be notified whenever NSUserDefault's domain or token value changed.
    override func observeValueForKeyPath(keyPath: String!,
        ofObject object: AnyObject!,
        change: [NSObject : AnyObject]!,
        context: UnsafePointer<()>) {
            
        let domain = app.userDefaults.stringForKey("domain")
        let token  = app.userDefaults.stringForKey("token")
        
        if (!(domain.isEmpty || token.isEmpty)) {
            self.sendIPChange()
        }
        else {
            self.setSuccess(false) // One of the values is empty.
        }
    }
    
    func setSuccess(success: Bool) {
        println("success changed to \(success)")
        self.app.userDefaults.setValue(success, forKey: "updateSucceeded")
    }
    
    func getSuccess()->Bool {
        return app.userDefaults.boolForKey("updateSucceeded")
    }
    
    func sendIPChange() {
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
    
    func getLastSentIP() -> String {
        var lastSentIp: String = NSUserDefaults().stringForKey("lastSentIP")
        
        //        if lastSentIp == nil {
        //            lastSentIp = ""
        //        }
        
        return lastSentIp
    }

}