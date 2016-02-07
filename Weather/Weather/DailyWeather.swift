//
//  DailyWeather.swift
//  Weather
//
//  Created by Brian Wong on 10/4/15.
//  Copyright © 2015 Brian Wong. All rights reserved.
//

import Foundation
import UIKit

struct DailyWeather{
    
    let maxTemperature: Int?
    let minTemperature: Int?
    let humidity: Int?
    let precipProbability: Int?
    let summary: String?
    let dateFormatter = NSDateFormatter()

    var sunsetTime: String?
    var sunriseTime: String?
    var day: String?
    var icon: UIImage? = UIImage(named: "default.png")
    var largeIcon: UIImage? = UIImage(named: "default_large.png")
    
    init(dailyWeatherDictionary: [String:AnyObject]){
        maxTemperature = dailyWeatherDictionary["temperatureMax"] as? Int
        minTemperature = dailyWeatherDictionary["temperatureMin"] as? Int
        summary = dailyWeatherDictionary["summary"] as? String
        
        //Humidity is returned as a float so we can't convert to int directly
        if let humidityFloat = dailyWeatherDictionary["humidity"] as? Double{
            humidity = Int(humidityFloat*100);
        }else{
            humidity = nil
        }
        
        if let precipProbFloat = dailyWeatherDictionary["precipProbability"] as? Double{
            precipProbability = Int(precipProbFloat * 100);
        }else{
            precipProbability = nil
        }
        
        if let iconString = dailyWeatherDictionary["icon"] as? String{
            if let iconEnum = WeatherIcon(rawValue: iconString){
                (icon, largeIcon) = iconEnum.toIcon()
            }
        }
        
        if let sunriseDate = dailyWeatherDictionary["sunriseTime"] as? Double{
            sunriseTime = timeStringFromUnixTime(sunriseDate)
        }else{
            sunriseTime = nil
        }
        
        if let sunsetDate = dailyWeatherDictionary["sunsetTime"] as? Double{
            sunsetTime = timeStringFromUnixTime(sunsetDate)
        }else{
            sunsetTime = nil
        }
        
        if let currentDay = dailyWeatherDictionary["time"] as? Double{
            day = dayStringFromTime(currentDay)
        }else{
            day = nil
        }
    }
    
    func timeStringFromUnixTime(unixTime: Double) -> String{
        let date = NSDate(timeIntervalSince1970: unixTime)
        
        //12 hour time format
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.stringFromDate(date)
    }
    
    func dayStringFromTime(time: Double) -> String{
        let date = NSDate(timeIntervalSince1970: time)
        //Using the current locale of the iPhone
        dateFormatter.locale = NSLocale(localeIdentifier: NSLocale.currentLocale().localeIdentifier)
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.stringFromDate(date)
    }
    
}
