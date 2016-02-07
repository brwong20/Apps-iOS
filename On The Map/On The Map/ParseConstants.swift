//
//  ParseConstants.swift
//  On The Map
//
//  Created by Brian Wong on 9/14/15.
//  Copyright (c) 2015 Brian Wong. All rights reserved.
//

import Foundation

extension ParseClient{
    
    //Constants
    struct Constants {
        // MARK: API Key
        static let RESTApiKey : String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ApplicationID : String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        
    }
    
    struct Methods{
        // MARK: URLs - Parse
        static let StudentLocation : String = "https://api.parse.com/1/classes/StudentLocation"
        static let UpdateStudentLocation : String = "https://api.parse.com/1/classes/StudentLocation/"
        static let QueryStudentLocation : String = "https://api.parse.com/1/classes/StudentLocation"
    }
    
    // MARK: - Parameter Keys
    struct ParameterKeys {
        
        static let ApiKey = "api_key"
        static let SessionID = "session_id"
        static let RequestToken = "request_token"
        static let Query = "query"
        
    }
    
    // MARK: - JSON Body Keys
    struct JSONBodyKeys {
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let StudentLink = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
    }
    
    // MARK: - JSON Response Keys
    struct JSONResponseKeys {
        static let LocationResults = "results"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Longitude = "longitude"
        static let Latitude = "latitude"
        static let MediaURL = "mediaURL"
        static let MapString = "mapString"
    }
    
}