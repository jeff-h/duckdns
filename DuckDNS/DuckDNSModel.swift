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

    var domain:  String = "" {
        didSet {
            println("Just changed domain from \(oldValue) to \(domain)")
        }
    }
    
    var token:   String = "" {
        didSet {
            println("Just changed token from \(oldValue) to \(token)")
        }
    }
    
    var lastKnownIP: String = "" {
        didSet {
            println("Just changed lastKnownIP from \(oldValue) to \(lastKnownIP)")
        }
    }
    
    var success: Bool = false {
        didSet {
            println("Just changed domain from \(oldValue) to \(success)")
        }
    }
    
    
    
    // MARK:- Initialisers and encoding
    override init() {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()

        domain      = aDecoder.decodeObjectForKey("domain") as String
        token       = aDecoder.decodeObjectForKey("token")  as String
        lastKnownIP = aDecoder.decodeObjectForKey("lastKnownIP") as String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(domain,       forKey: "domain")
        aCoder.encodeObject(token,        forKey: "token")
        aCoder.encodeObject(lastKnownIP,  forKey: "lastKnownIP")
    }
    
    deinit {
        println("ran deinit")
    }
    
    
    // MARK:- Helper functions
    
    func credentialsChanged() {
        println("creds changed")
        self.updateCheck()
    }
    
    func updateCheck() {
        // Only continue if the token and domain credentials are available.
        if self.domain != "" && self.token != "" {
            // Ping the external IP website to see if our external IP has
            // actually changed.
            var currentIP = fetchPublicIP()
            if currentIP != lastKnownIP {
                // If our external IP has changed, store it, then ping Duck DNS.
                self.lastKnownIP = currentIP
                
                println("pinging Duck DNS")
                self.success = updateDuckDNS()
            }
        }
    }
    
    // Get the public IP. Return "" if the request fails.
    func fetchPublicIP() ->String {
        var resultString = ""
        
        // Fetch public IP from http://echoip.net
        let url = NSURL(string: "http://echoip.net")
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
            resultString = (NSString(data: data, encoding: NSUTF8StringEncoding))
        }
        task.resume()
        
        return resultString
    }

    func updateDuckDNS() -> Bool {
        var success = false
        let url = NSURL(string: "https://www.duckdns.org/update?domains=" + domain + "&token=" + token + "&ip=")
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
            let resultString = (NSString(data: data, encoding: NSUTF8StringEncoding))
            success = (resultString == "OK")
        }
        task.resume()
        
        return success
    }
}