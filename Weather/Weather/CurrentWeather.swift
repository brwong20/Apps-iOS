//
//  CurrentWeather.swift
//  Weather
//
//  Created by Brian Wong on 9/28/15.
//  Copyright © 2015 Brian Wong. All rights reserved.
//

import Foundation
import UIKit

struct CurrentWeather{
    
    //All data storage is set as an optional because the forecast data may or may not have these values
    
    let temperature: Int?
    let humidity: Int?
    let precipProbability: Int?
    let summary: String?
    
    /*Failable initializer for default - function: To account for an icon that isn'recognized in the future.
    If the icon we retrieve from Forecast is nil or not in our list, the icon is set to the failable init icon (default.png)*/
    var icon: UIImage? = UIImage(named: "default.png")
    
    //Parse weather data
    init(weatherDictionary: [String:AnyObject]){
        temperature = weatherDictionary["temperature"] as? Int
        
        //Safely unwrapping/casting the number to Double, then converting to Int
        if let humidityFloat = weatherDictionary["humidity"] as? Double {
            humidity = Int(humidityFloat*100)
        }else{
            humidity = nil
        }
        
        if let precipProbFloat = weatherDictionary["precipProbability"] as? Double {
            precipProbability = Int(precipProbFloat*100)
        }else{
            precipProbability = nil
        }
        
        summary = weatherDictionary["summary"] as? String
        
        //Chaining optional unwraps to create enum instance (rawValue is a failable init)
        if let iconString = weatherDictionary["icon"] as? String,
            let weatherIcon: WeatherIcon = WeatherIcon(rawValue: iconString){
                //Find the enum case(choice) for icon string then return the actual image name
                //NOTE: The underscore means we DON'T care about the value of the second part of the tuple(largeIcon)
                (icon, _) = weatherIcon.toIcon()
        }
    }
}

