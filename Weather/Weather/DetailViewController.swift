//
//  DetailViewController.swift
//  Weather
//
//  Created by Brian Wong on 10/6/15.
//  Copyright © 2015 Brian Wong. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var largeIconImage: UIImageView?
    @IBOutlet weak var summaryTextLabel: UILabel?
    @IBOutlet weak var sunriseTimeLabel: UILabel?
    @IBOutlet weak var sunsetTimeLabel: UILabel?
    @IBOutlet weak var lowTempLabel: UILabel?
    @IBOutlet weak var highTempLabel: UILabel?
    @IBOutlet weak var rainChanceLabel: UILabel?
    @IBOutlet weak var humidityLabel: UILabel?
    
    //When we get a dailyWeather item, configure the views
    var dailyWeather: DailyWeather?{
        didSet{
            configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView() //Need to call because IBOutlets are initialized after didSet method above
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        configureView()
    }

    func configureView(){
        if let weather = dailyWeather{
            //Set the nav bar's title
            self.title = weather.day!
            
            //Update the rest of the UI by chain unwrapping all optionals in our DailyWeather object

            self.largeIconImage?.image = weather.largeIcon
            self.summaryTextLabel?.text = weather.summary
            self.sunriseTimeLabel?.text = weather.sunriseTime
            self.sunsetTimeLabel?.text = weather.sunsetTime
            
            if  let  lowTemp = weather.minTemperature,
                let highTemp = weather.maxTemperature,
                let precipChance = weather.precipProbability,
                let humidity = weather.humidity{
                    self.lowTempLabel?.text = "\(lowTemp)º"
                    self.highTempLabel?.text = "\(highTemp)º"
                    self.rainChanceLabel?.text = "\(precipChance)%"
                    self.humidityLabel?.text = "\(humidity)%"
            }
        }
        
        //Set nav bar back button
        if let backButtonFont = UIFont(name: "HelveticaNeue-Thin", size: 20.0){
            //Make bar button have white font
            let barButtonAttributesDictionary: [String:AnyObject]? = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: backButtonFont]
            UIBarButtonItem.appearance().setTitleTextAttributes(barButtonAttributesDictionary, forState: .Normal)
            
            //To change arrow color: change the nav bar's View's TINT color
        }
    }
}
