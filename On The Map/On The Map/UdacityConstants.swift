//
//  UdacityConstants.swift
//  On The Map
//
//  Created by Brian Wong on 9/14/15.
//  Copyright (c) 2015 Brian Wong. All rights reserved.
//

import Foundation

extension UdacityClient{
    
    struct Methods{
        // MARK: URLs - Udacity
        static let UdacityBaseURLSecure : String = "https://www.udacity.com/api/session"
        static let GetPublicData : String = "https://www.udacity.com/api/users/"
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
        static let Username = "username"
        static let Password = "password"
        static let Udacity = "udacity"
    }
    
    // MARK: - JSON Response Keys
    struct JSONResponseKeys {
        static let AccountLogin = "account"
        static let AccountRegistered = "registered"
        static let UserID = "key"
    }
}