//
//  IconSelection.swift
//  Weather
//
//  Created by Brian Wong on 10/5/15.
//  Copyright © 2015 Brian Wong. All rights reserved.
//

import Foundation
import UIKit

/*Refactored into a separate file to adhere to single responsibility principle*/

//List of constant, reusable values to show weather as an icon
//We use an enum to achieve this to remove the responsibility on the CurrentWeather's init method!
enum WeatherIcon: String {
    case ClearDay = "clear-day"
    case ClearNight = "clear-night"
    case Rain = "rain"
    case Snow = "snow"
    case Sleet = "sleet"
    case Wind = "wind"
    case Fog = "fog"
    case Cloudy = "cloudy"
    case PartlyCloudyDay = "partly-cloudy-day"
    case PartlyCloudyNight = "partly-cloudy-night"
    
    /*Helper method to sort and set the icon based on the icon's String
      Placed in here so the entire enum is more versatile and can be used in other classes
      NOTE: We return a tuple of images for convenience*/
    func toIcon() -> (regularIcon: UIImage?, largeIcon: UIImage?){
        
        var imageName : String
        
        //Raw value intialization : when we create an instance, this switch statment performs a switch on the rawValue passed in (needed to create instance) and determines which image to use based on the String
        
        switch self{
            
        case .ClearDay:
            imageName = "clear-day"
        case .ClearNight:
            imageName = "clear-night"
        case .Rain:
            imageName = "rain"
        case .Snow:
            imageName = "snow"
        case .Sleet:
            imageName = "sleet"
        case .Wind:
            imageName = "wind"
        case .Fog:
            imageName = "fog"
        case .Cloudy:
            imageName = "cloudy"
        case .PartlyCloudyDay:
            imageName = "cloudy-day"
        case .PartlyCloudyNight:
            imageName = "cloudy-night"
        }
        let regularIcon = UIImage(named: "\(imageName).png")
        let largeIcon = UIImage(named: "\(imageName)_large.png")
        
        return(regularIcon, largeIcon)
    }
}