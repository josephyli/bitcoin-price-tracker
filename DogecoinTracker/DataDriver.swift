//
//  DataDriver.swift
//  DogecoinTracker
//
//  Created by David Lin on 11/3/15.
//  Copyright © 2015 Myzithra. All rights reserved.
//

import Foundation

class DataDriver {
    var request = HTTPTask()
    request.GET("http://vluxe.io", parameters: nil, success: {(response: HTTPResponse) in
    if response.responseObject != nil {
    let data = response.responseObject as NSData
    let str = NSString(data: data, encoding: NSUTF8StringEncoding)
    println("response: \(str)") //prints the HTML of the page
    }
    },failure: {(error: NSError) in
    println("error: \(error)")
    })
}
/*
// http://stackoverflow.com/questions/24016142/how-to-make-an-http-request-in-swift
class DataDriver : NSObject {
    let url = NSURL(string: "http://www.stackoverflow.com")
    
    let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
        println(NSString(data: data, encoding: NSUTF8StringEncoding))
    }
    
    task.resume()
}
*/

/*
// https://gist.github.com/frozzare/cfb79749e56b5abb00c7
class DataDriver : NSObject {
    
    var url : NSURL? = nil
    var request : NSMutableURLRequest? = nil
    var response : NSHTTPURLResponse? = nil
    
    var data: NSMutableData? = nil
    var done: (NSError?, NSData, NSString?) -> () = { (_, _, _) -> () in }
    
    init (method: String, url: String, done: (NSError?, NSData, NSString?) -> ()) {
        let _url = NSURL(string: url)
        self.request = NSMutableURLRequest(URL: _url!)
        self.request!.HTTPMethod = method;
        self.done = done
        self.data = NSMutableData()
    }
    
    func start () {
        _ = NSURLConnection(request: self.request!, delegate: self, startImmediately: true)
    }
    
    class func get (url: String, done: (NSError?, NSData, NSString?) -> ()) -> Void {
        return Request(method: "GET", url: url, done: done).start();
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        self.data!.appendData(data)
    }
    
    func connection(connection: NSURLConnection!, didReceiveResponse response: NSHTTPURLResponse!) {
        self.response = response
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        let text = NSString(data: self.data!, encoding: NSUTF8StringEncoding)
        self.done(nil, self.data!, text)
    }
    
    func connection(connection: NSURLConnection!, didFailWithError error: NSError!) {
        self.done(error, nil!, nil)
    }
}

func waitFor (inout wait: Bool) {
    while (wait) {
        NSRunLoop.currentRunLoop().runMode(NSDefaultRunLoopMode,
            beforeDate: NSDate(timeIntervalSinceNow: 0.1))
    }
}

var wait: Bool = true

Request.get("http://svt.se", { (error: NSError?, data: NSData, text: NSString?) -> () in
    println(text)
    wait = false
})

waitFor(&wait)
*/