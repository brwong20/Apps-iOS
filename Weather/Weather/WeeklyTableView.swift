//
//  WeeklyTableView.swift
//  Weather
//
//  Created by Brian Wong on 9/30/15.
//  Copyright © 2015 Brian Wong. All rights reserved.
//

import UIKit
import CoreLocation

class WeeklyTableView: UITableViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var currentRainLabel: UILabel?
    @IBOutlet weak var currentIcon: UIImageView?
    @IBOutlet weak var currentLocationLabel: UILabel?
    @IBOutlet weak var currentTemperatureLabel: UILabel?
    @IBOutlet weak var currentHiLowLabel: UILabel?
    
    private let forecastAPIKey: String = "dcee4386a92b30a378582ccd4091306d"
    
    //Takes care of location
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    var currentLat: Double = 0.0
    var currentLon: Double = 0.0
    
    //Holds the weekly forecast
    var weeklyWeather: [DailyWeather] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        configureViews()
    }
    
    //Called to update a little after views are set up or else default is displayed and user will have to refresh to get actual forecast
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.01 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.retrieveWeather()
        }
    }
    
    func configureViews(){
        //Set table view background
        tableView.backgroundView = BackgroundView()
        
        //Set table cell row height
        tableView.rowHeight = 64
        
        //Set nav bar font and size
        if let navBarFont = UIFont(name: "HelveticaNeue-Thin", size: 20.0){
            //Set text color, then font style
            let navBarAttributesDictionary: [String:AnyObject]? = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: navBarFont]
            navigationController?.navigationBar.titleTextAttributes = navBarAttributesDictionary
        }
        
        //Layer refresh control on top
        refreshControl?.layer.zPosition = tableView.backgroundView!.layer.zPosition + 1
        refreshControl?.tintColor = UIColor.whiteColor()

    }
    
    @IBAction func refreshWeather() {
        retrieveWeather()
        refreshControl?.endRefreshing()
    }
   
    // MARK: - Table view delegate methods
    
    //Sets the color of the header before it's displayed
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor(red: 170.0/255.0, green: 131.0/255.0, blue: 224.0/255.0, alpha: 1.0)
        
        //Cast the current generic view to a UITableViewHeaderFooterView to change even more of its properties
        if let headerView = view as? UITableViewHeaderFooterView{
            headerView.textLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 14.0)
            headerView.textLabel?.textColor = UIColor.whiteColor()
        }
    }
    
    //Custom highlight color
    override func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.contentView.backgroundColor = UIColor(red: 165/255.0, green: 142/255.0, blue: 203/255.0, alpha: 1.0)
        let highlightView = UIView()
        highlightView.backgroundColor = UIColor(red: 165/255.0, green: 142/255.0, blue: 203/255.0, alpha: 1.0)
        cell?.selectedBackgroundView = highlightView
    }

    // MARK: - Table view data source methods

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //Sets section header
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Forecast"
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weeklyWeather.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //Using our custom instances of UITableViewCell
        let cell = tableView.dequeueReusableCellWithIdentifier("WeatherCell") as! WeeklyTableViewCell
        
        let weatherForDay = weeklyWeather[indexPath.row]
        if let maxTemp = weatherForDay.maxTemperature{
            cell.temperatureLabel.text = "\(maxTemp)º"
        }
        if let currentDay = weatherForDay.day{
            cell.currentDayLabel.text = currentDay
        }
        cell.weatherIcon.image = weatherForDay.icon
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showWeatherDetail", sender: self)
    }
    
    func retrieveWeather(){
        let forecastClient = ForecastClient(APIKey: forecastAPIKey).getForecast(currentLat, lon:currentLon){
            (let forecast) in /*Shorthand closure expression*/
            if let weatherForecast = forecast{//Updated: Unwrap the ForecastData object then use it to get current weather
                if let currentWeather = weatherForecast.currentWeather{
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                        //Safely unwrapping all CurrentWeather optional values
                        
                        if let temperature = currentWeather.temperature{
                            self.currentTemperatureLabel?.text = "\(temperature)º"
                        }
                        
                        if let precipitation = currentWeather.precipProbability{
                            self.currentRainLabel?.text = "Rain: \(precipitation)%"
                        }
                        
                        if let icon = currentWeather.icon{
                            self.currentIcon?.image = icon
                        }
                        
                        self.weeklyWeather = weatherForecast.weekly
                        
                        //Using our array, the first element(current day) will give us today's high and low temp
                        if let highTemp = self.weeklyWeather.first?.maxTemperature{
                            if let lowTemp = self.weeklyWeather.first?.minTemperature{
                                self.currentHiLowLabel?.text = "↟\(highTemp)º↡\(lowTemp)º"
                            }
                        }
                        
                        //Force rebuilding of tableview since tableview is built first, the data isnt stored in the cells
                        self.tableView.reloadData()
                        
                        self.locationManager.stopUpdatingLocation()
                        print("Call")
                    })
                }
            } else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.currentTemperatureLabel?.text = "0º"
                    self.currentRainLabel?.text = "0%"
                })
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.first
        
        self.geocoder.reverseGeocodeLocation(location!) { (placemarks, error) -> Void in
            if let placemark = placemarks?.first as? AnyObject{
                if let localityName = placemark.locality,
                let countryName = placemark.country{
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.currentLocationLabel?.text = "\(localityName!), \(countryName!)"
                    })
                }
        
            }else{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.currentLocationLabel?.text = "Couldn't retrieve location..."
                })
            }
        }
        
        if let currentLongitude = location?.coordinate.longitude{
            currentLon = currentLongitude
        }
        
        if let currentLatitude = location?.coordinate.latitude{
            currentLat = currentLatitude
        }
        
    }
    
    //MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showWeatherDetail"){
            if let indexPath = tableView.indexPathForSelectedRow{ //Another way to get index path
                let dailyWeather = weeklyWeather[indexPath.row];
                
                //Another way to set destination VC's property
                
                (segue.destinationViewController as! DetailViewController).dailyWeather = dailyWeather
            }
        }
    }
}
