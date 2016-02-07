//
//  ParseStudent.swift
//  On The Map
//
//  Created by Brian Wong on 9/17/15.
//  Copyright (c) 2015 Brian Wong. All rights reserved.
//

import Foundation

struct ParseStudent {
    
    var firstName: String? = nil
    var lastName: String? = nil
    var latitude: Double? = nil
    var longitude: Double? = nil
    var mediaURL: String? = nil
    var mapString: String? = nil
    static var students = [ParseStudent]()
    
    /* Get a the an entire student's info with a dictionary */
    init(dictionary: [String : AnyObject]) {
        
        firstName = dictionary[ParseClient.JSONResponseKeys.FirstName] as? String
        lastName = dictionary[ParseClient.JSONResponseKeys.LastName] as? String
        latitude = dictionary[ParseClient.JSONResponseKeys.Latitude] as? Double
        longitude = dictionary[ParseClient.JSONResponseKeys.Longitude] as? Double
        mediaURL = dictionary[ParseClient.JSONResponseKeys.MediaURL] as? String
        mapString = dictionary[ParseClient.JSONResponseKeys.MapString] as? String
        
    }
    
    /* Helper: Given an array of dictionaries, convert them to an array of ParseStudent objects */
    static func locationsFromResults(results: [[String : AnyObject]]) -> Void {
        for result in results {
            students.append(ParseStudent(dictionary: result))
        }
    }
}