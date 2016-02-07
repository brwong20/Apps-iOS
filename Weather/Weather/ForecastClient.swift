//
//  ForecastClient.swift
//  Weather
//
//  Created by Brian Wong on 9/29/15.
//  Copyright © 2015 Brian Wong. All rights reserved.
//

import Foundation

class ForecastClient{
    
    let forecastAPIKey: String
    let forecastBaseURL: NSURL?
    
    init(APIKey: String){
        self.forecastAPIKey = APIKey
        self.forecastBaseURL = NSURL(string: "https://api.forecast.io/forecast/\(self.forecastAPIKey)/")
    }
    
    //Returns a ForecastData by using it as a wrapper object to get the current weather
    func getForecast(lat: Double, lon: Double, completion:(ForecastData? -> Void)) {
        //Safely unwrap the NSURL
        if let forecastURL = NSURL(string: "\(lat),\(lon)", relativeToURL: forecastBaseURL){
            
            let networkOperation = NetworkOperation(url: forecastURL)
            
            //Short hand closure expression
            networkOperation.downloadJSONFromURL{
                (let JSONDictionary) in
                let forecast = ForecastData(weatherDictionary: JSONDictionary)
                completion(forecast)
            }
        }
    }
    
    //Integrated into wrapper object: ForecastData
    
//    func currentWeatherFromJSON(jsonDictionary: [String:AnyObject]?) -> CurrentWeather? {
//        
//        //Safely setting an optional dictionary to a constant
//        if let currentWeatherDictionary = jsonDictionary?["currently"] as? [String:AnyObject]{
//            return CurrentWeather(weatherDictionary: currentWeatherDictionary)
//        } else {
//            print("JSON dictionary returned nil for 'currently' key")
//            return nil
//        }
//    }
    
}