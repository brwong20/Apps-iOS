//
//  ForecastClient.swift
//  Weather
//
//  Created by Brian Wong on 9/28/15.
//  Copyright © 2015 Brian Wong. All rights reserved.
//

import Foundation

class NetworkingOperation{
    
    let forecastAPIKey: String = "dcee4386a92b30a378582ccd4091306d"
    
    //Only initialized when class is called
    lazy var session = NSURLSession.sharedSession()
    let queryURL: NSURL
    
    typealias JSONDictionaryCompletion = ([String:AnyObject]?) -> Void
    
    init(url:NSURL){
        self.queryURL = url
    }
    
    func downloadJSONFromURL(completion: JSONDictionaryCompletion) {
        let request = NSURLRequest(URL: self.queryURL)
        let dataTask = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            //Check the status code to see if request was successful. If it was, create a JSON object
            do{
                if let httpResponse = response as? NSHTTPURLResponse{
                    switch(httpResponse.statusCode){
                    case 200:
                        let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? [String:AnyObject]
                        completion(jsonDictionary)
                    default:
                        print("Status code not successful: \(httpResponse.statusCode)")
                    }
                } else {
                    print("Error: Not a valid HTTP response")
                }
            }catch{
                
            }
        }
        dataTask.resume()
    }
}
