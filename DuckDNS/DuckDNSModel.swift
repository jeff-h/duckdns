//
//  DuckDNSModel.swift
//  DuckDNS
//
//  Created by Jeff Hanbury on 13/07/2014.
//  Copyright (c) 2014 Marmaladesoul. All rights reserved.
//

import Foundation

class DuckDNSModel: NSObject, NSCoding {
    
    // MARK:- Properties
//    let app = NSApplication.sharedApplication().delegate as AppDelegate
    var domain:  String = ""
    var token:   String = ""
    var lastKnownIP: String = ""
    var success: Bool = false
    
    // MARK:- Initialisers and encoding
    override init() {
        println("main init")
        super.init()
        
        println("domain before: \(domain)")
        domain = "hoohar"
        // Watch for changes to specific defaults.
//        let options : NSKeyValueObservingOptions = .New | .Old
        
//        app.userDefaults.addObserver(self, forKeyPath: "domain", options: options, context: nil)
//        app.userDefaults.addObserver(self, forKeyPath: "token",  options: options, context: nil)
//        app.userDefaults.addObserver(self, forKeyPath: "lastKnownIP",  options: options, context: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
        println("init: decode with coder")
        domain      = aDecoder.decodeObjectForKey("domain") as String
        token       = aDecoder.decodeObjectForKey("token")  as String
        lastKnownIP = aDecoder.decodeObjectForKey("lastKnownIP") as String
        println("domain \(domain) and token \(token) and lastKnownIP \(lastKnownIP)")
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        println("encode with coder")
        aCoder.encodeObject(domain,       forKey: "domain")
        aCoder.encodeObject(token,        forKey: "token")
        aCoder.encodeObject(lastKnownIP,  forKey: "lastKnownIP")
    }
    
    deinit {
        println("here deinit")
//        app.userDefaults.removeObserver(self, forKeyPath: "domain")
//        app.userDefaults.removeObserver(self, forKeyPath: "token")
//        app.userDefaults.removeObserver(self, forKeyPath: "lastKnownIP")
    }
    
    
    // MARK:- Helper functions
    func save() {
        let success = NSKeyedArchiver.archiveRootObject(self, toFile: "gloppo77.data")
        println("success was \(success)")
    }
    
    func load() ->DuckDNSModel {
//        var defaults = NSUserDefaults.standardUserDefaults()  // NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        var archivedObject = defaults.objectForKey("courses") as NSData  // NSData *archivedObject = [defaults objectForKey:<key_for_archived_object>];
//        History = NSKeyedUnarchiver.unarchiveObjectWithData(archivedObject) as Dictionary<String,course>   //<your_class> *obj = (<your_class> *)[NSKeyedUnarchiver unarchiveObjectWithData:archivedObject];
        println("about to load DuckDNSModel")
        return NSKeyedUnarchiver.unarchiveObjectWithFile("gloppo77.data") as DuckDNSModel
    }

    
    // We'll be notified whenever NSUserDefault's domain, token or lastKnownIP
    // values changed.
//    override func observeValueForKeyPath(
//        keyPath: String!,
//        ofObject object: AnyObject!,
//        change: [NSObject : AnyObject]!,
//        context: UnsafeMutablePointer<()>) {
//
//        switch (keyPath!) {
//            case "lastKnownIP":
////                if (change["old"] != change["new"]) {
//                    println("observed val change in lastKnownIP")
//                    println(change)
//                    self.sendIPChange()
////                }
//            
//            case "domain", "token":
//                let domain = app.userDefaults.stringForKey("domain")
//                let token  = app.userDefaults.stringForKey("token")
//                
//                if (!(domain!.isEmpty || token!.isEmpty)) {
//                    // Which will in turn trigger a Duck DNS update if the IP changes
//                    // from the last known value.
//                    self.setCurrentIP()
//                    //self.sendIPChange()
//                }
//                else {
//                    self.setSuccess(false) // One of the values is empty.
//                }
//            
//            default:
//                // We're not handling these.
//                super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
//        }
//    }
    
    func setSuccess(success: Bool) {
        println("Set updateSucceeded to \(success)")
        self.success = success
//        self.app.userDefaults.setValue(success, forKey: "updateSucceeded")
    }
    
    func getSuccess()->Bool {
        return success; //app.userDefaults.boolForKey("updateSucceeded")
    }
    
    func sendIPChange() {
        println("pinging Duck DNS")
        
//        let domain = app.userDefaults.stringForKey("domain")
//        let token  = app.userDefaults.stringForKey("token")
        let url = NSURL(string: "https://www.duckdns.org/update?domains=" + domain + "&token=" + token + "&ip=")

        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
            let resultString = (NSString(data: data, encoding: NSUTF8StringEncoding))
            let success = (resultString == "OK")
            self.setSuccess(success)
        }
        task.resume()
    }
    
    func getLastKnownIP() -> String {
        return lastKnownIP // app.userDefaults.stringForKey("lastKnownIP")!
    }

    // Get the public IP, and save it to user defaults. If it's changed,
    // user defaults will trigger a change event.
    func setCurrentIP() {
        // Fetch public IP from http://echoip.net
        let url = NSURL(string: "http://echoip.net")
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
            let resultString = (NSString(data: data, encoding: NSUTF8StringEncoding))
            // self.app.userDefaults.setValue(resultString, forKey: "lastKnownIP")
            self.lastKnownIP = resultString
        }
        task.resume()
    }

}