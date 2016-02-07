//
//  ParseConvenience.swift
//  On The Map
//
//  Created by Brian Wong on 9/14/15.
//  Copyright (c) 2015 Brian Wong. All rights reserved.
//

import Foundation

extension ParseClient{
    
    //update method - remember to sub key in for method THEN pass into client function
    //Use Constants.UpdateStudentLocation and sub with current user id
    
    //Query method - escape the dictionary w/ uniqueKey first THEN pass into client method
    
    //Loop through for all students aka pins
    
    func getStudentLocations(completionHandler:(success: Bool, locations:[[String:AnyObject]], errorString: String?) -> Void){
        
        taskForGetMethod { (result, error) -> Void in
            if let parseError = error{
                print(parseError)
            }else{
                if let locations: AnyObject = result{
                    let locationDictionary = locations.valueForKey(JSONResponseKeys.LocationResults) as! [[String:AnyObject]]
                    ParseStudent.locationsFromResults(locationDictionary)
                    completionHandler(success:true, locations: locationDictionary, errorString: "Error in parsing student locations")
                }else{
                    print("Failed to get locations")
                }
            }
        }
    }
    
    func postStudentLocation(uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: NSNumber, longitude: NSNumber, completionHandler:(success:Bool, error: String) -> Void){
    
        let jsonBody: [String:AnyObject] = [
            JSONBodyKeys.UniqueKey: self.userID,
            JSONBodyKeys.FirstName : firstName,
            JSONBodyKeys.LastName : lastName,
            JSONBodyKeys.MapString : mapString,
            JSONBodyKeys.StudentLink : mediaURL,
            JSONBodyKeys.Latitude : latitude,
            JSONBodyKeys.Longitude : longitude
        ]
        
        taskForPOSTMethod(jsonBody, completionHandler: { (result, error) -> Void in
            if let error = error{
                print(error)
                completionHandler(success: false, error: "Error in posting")
                print("Error in posting")
                //TODO: Replace with alertview
            }else{
                if let postSuccess: AnyObject = result{
                    completionHandler(success: true, error: "Post success!")
                }
            }
        })
    }
    
    //Return the objectId when finished, since this is the only piece of data we need to update(PUT) a new location
    func queryExistingLocation(userId:String, completionHandler:(success:String?, error: String) -> Void){
        taskForQueryMethod(userId, completionHandler: { (result, error) -> Void in
            if let error = error{
                print("Query failed")
                completionHandler(success: nil, error: "Failed in querying")
            }else{
                if let querySuccess: AnyObject = result{
                    let jsonData = JSON(querySuccess)
                    let objectId = jsonData["results"][0]["objectId"].stringValue
                    completionHandler(success: objectId, error: "")
                }
            }
        })
    }
    
    func updateStudentLocation(objectId: String, uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: NSNumber, longitude: NSNumber, completionHandler:(success:Bool, error: String) -> Void){
        
        let jsonBody: [String:AnyObject] = [
            JSONBodyKeys.UniqueKey: self.userID,
            JSONBodyKeys.FirstName : firstName,
            JSONBodyKeys.LastName : lastName,
            JSONBodyKeys.MapString : mapString,
            JSONBodyKeys.StudentLink : mediaURL,
            JSONBodyKeys.Latitude : latitude,
            JSONBodyKeys.Longitude : longitude
        ]
        
        taskForPutMethod(objectId, jsonBody: jsonBody) { (result, error) -> Void in
            if let error = error{
                NSLog("%@", error)
                //Alert view
                print("Error in updating pin")
                completionHandler(success: false, error: "Error in putting")
            }else{
                if let putSuccess: AnyObject = result{
                    completionHandler(success: true, error: "")
                }
            }
        }
        
    }
}