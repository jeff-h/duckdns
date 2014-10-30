//
//  DuckDNSModel.swift
//  DuckDNS
//
//  Created by Jeff Hanbury on 13/07/2014.
//  Copyright (c) 2014 Marmaladesoul. All rights reserved.
//

import Foundation


protocol DuckDNSModelDelegate {
    func willCheckExternalIP()
    func  didCheckExternalIP(ip: String)
    
    func willUpdateDuckDNS()
    func didUpdateDuckDNS(success: Bool)
}

public class DuckDNSModel: NSObject, NSCoding {
    
    // MARK:- Properties

    var delegate: DuckDNSModelDelegate? = nil
    
    public var domain: String = "" {
        didSet {
            self.updateDuckDNS()
        }
    }
    
    public var token: String = "" {
        didSet {
            self.updateDuckDNS()
        }
    }
    
    public var lastKnownIP: String = "" {
        didSet {
            // If our external IP has changed, ping Duck DNS.
            if lastKnownIP != oldValue {
                self.updateDuckDNS()
            }
        }
    }
    
    public var success: Bool = false {
        didSet {
            println("Just changed success from \(oldValue) to \(success)")
        }
    }
    
    class var modelDataPath: String {
        return NSSearchPathForDirectoriesInDomains(.ApplicationSupportDirectory, .UserDomainMask, true)[0] as String + "/data.archive"
    }

    
    // MARK:- Singleton
    
    public class var sharedInstance: DuckDNSModel {
        struct Singleton {
            static var onceToken : dispatch_once_t = 0
            static var instance : DuckDNSModel? = nil
        }
        
        dispatch_once(&Singleton.onceToken) {
            Singleton.instance = NSKeyedUnarchiver.unarchiveObjectWithFile(self.modelDataPath) as DuckDNSModel?
            
            if Singleton.instance == nil {
                Singleton.instance = DuckDNSModel()
            }
        }
        
        return Singleton.instance!
    }
    
    
    // MARK:- Initialisers and encoding
    
    override init() {
        super.init()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init()

        domain      = aDecoder.decodeObjectForKey("domain") as String
        token       = aDecoder.decodeObjectForKey("token")  as String
        lastKnownIP = aDecoder.decodeObjectForKey("lastKnownIP") as String
    }
    
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(domain,       forKey: "domain")
        aCoder.encodeObject(token,        forKey: "token")
        aCoder.encodeObject(lastKnownIP,  forKey: "lastKnownIP")
    }
        
    
    // MARK:- Load & save
    
    private func loadModel() -> DuckDNSModel {
        var model = NSKeyedUnarchiver.unarchiveObjectWithFile(DuckDNSModel.modelDataPath) as DuckDNSModel?
        
        if model == nil {
            model = DuckDNSModel()
        }
        
        return model!
    }
    
    public func saveModel() -> Bool {
        let success = NSKeyedArchiver.archiveRootObject(
            DuckDNSModel.sharedInstance,
            toFile: DuckDNSModel.modelDataPath
        )

        return success
    }

    
    // MARK:- Helper functions
    
    // Get the public IP. Return "" if the request fails.
    func fetchPublicIP() {
        var resultString = ""
        
        delegate?.willCheckExternalIP()

        // Fetch public IP from http://echoip.net
        let url = NSURL(string: "http://echoip.net")!
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
            
            println("error code \(error)")
            
            resultString = (NSString(data: data, encoding: NSUTF8StringEncoding))!
            self.lastKnownIP = resultString
            self.delegate?.didCheckExternalIP(resultString)
        }
        task.resume()
    }

    func updateDuckDNS() {
        // Only continue if the token, domain and IP are available.
        if self.domain != "" && self.token != "" && self.lastKnownIP != "" {
            delegate?.willUpdateDuckDNS()

            let url = NSURL(string: "https://www.duckdns.org/update?domains=" + domain + "&token=" + token + "&ip=")!
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
                
                if (error != nil) {
                    println("Error received: \(error)")
                }
                
                let resultString = (NSString(data: data, encoding: NSUTF8StringEncoding))
                self.success = (resultString == "OK")
                self.delegate?.didUpdateDuckDNS(self.success)
            }
            
            task.resume()
        }
    }
}
