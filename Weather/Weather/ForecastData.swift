//
//  ForecastData.swift
//  Weather
//
//  Created by Brian Wong on 10/5/15.
//  Copyright © 2015 Brian Wong. All rights reserved.
//

import Foundation

struct ForecastData{
    var currentWeather: CurrentWeather?
    var weekly: [DailyWeather] = []
    
    init(weatherDictionary:[String:AnyObject]?){
        //Safely setting an optional dictionary to a constant
        if let currentWeatherDictionary = weatherDictionary?["currently"] as? [String:AnyObject]{
            currentWeather = CurrentWeather(weatherDictionary: currentWeatherDictionary)
        }
        if let weeklyWeatherArray = weatherDictionary?["daily"]?["data"] as? [[String:AnyObject]]{
            
            //Loop through and get each dictionary, create a DailyWeather from it, then append to our var
            for dailyWeather in weeklyWeatherArray{
                let weatherForDay = DailyWeather(dailyWeatherDictionary: dailyWeather)
                weekly.append(weatherForDay)
            }
        }
        
    }
}