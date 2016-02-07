//
//  MapGeoCoder.swift
//  On The Map
//
//  Created by Brian Wong on 9/18/15.
//  Copyright (c) 2015 Brian Wong. All rights reserved.
//

import MapKit
import UIKit
import CoreLocation

class MapGeoCoder: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var streetNameField: UITextField!
    @IBOutlet weak var cityNameField: UITextField!
    @IBOutlet weak var countryNameField: UITextField!
    @IBOutlet weak var locationPromptView: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var fetchLocationButton: UIButton!
    @IBOutlet weak var mediaUrlPromptLabel: UILabel!
    @IBOutlet weak var mediaUrlField: UITextField!
    @IBOutlet weak var submitLocationButton: UIButton!
    @IBOutlet weak var mediaUrlView: UIView!
    
    //Shared instances
    let udacityInstance = UdacityClient.sharedInstance()
    let parseInstance = ParseClient.sharedInstance()
    
    //User location info
    var mapString: String = ""
    var userLat:NSNumber = 0.0
    var userLon:NSNumber = 0.0
    
    //Geocoder instance
    let geocoder = CLGeocoder()
    
    //Track input data here and gather it to call post convenience method when SUBMIT button is clicked
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        self.mediaUrlView.hidden = true
        self.mediaUrlPromptLabel.hidden = true
        self.mediaUrlField.hidden = true
        self.mapView.hidden = true
    }
    
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    @IBAction func fetchLocationPrssed(sender: UIButton) {
        
        let streetName = self.streetNameField.text
        let cityName = self.cityNameField.text
        let countryName = self.countryNameField.text
        let address = NSString(format: "%@ %@ %@", streetName!, cityName!, countryName!)
        self.mapString = address as String
        
        self.fetchLocationButton.hidden = true
        self.locationPromptView.hidden = true
        self.streetNameField.hidden = true
        self.cityNameField.hidden = true
        self.countryNameField.hidden = true
        
        self.mediaUrlView.hidden = false
        self.mediaUrlPromptLabel.hidden = false
        self.mediaUrlField.hidden = false
        self.mapView.hidden = false
        self.geocoder.geocodeAddressString(address as String) { (placemarks, error) -> Void in
            if let locationError = error{
                NSLog("@%", locationError)
            }else{
                if let retrievedLocation:[AnyObject] = placemarks{
                    let placemark = retrievedLocation.first as! CLPlacemark
                    self.zoomInLocation(placemark)
                }
            }
        }
        
    }
    
    //Helper function used delay the map from loading ever so slightly
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    @IBAction func submitLocationPressed(sender: UIButton) {
        
        //TODO: Post function first, then check if user has posted
        
        //Get user data
        udacityInstance.taskForGetUserData { (result, error) -> Void in
            if let userData: AnyObject  = result{
                let userDictionary = userData["user"] as! NSDictionary
                let userId = userDictionary["key"] as! String
                let firstName = userDictionary["first_name"] as! String
                let lastName = userDictionary["last_name"] as! String
                
                
                //Find first, then put, if not post
                self.parseInstance.queryExistingLocation(userId, completionHandler: { (success, error) -> Void in
                    if let objectID = success{
                        if(objectID != ""){
                            //Put
                            self.parseInstance.updateStudentLocation(objectID, uniqueKey: userId, firstName: firstName, lastName: lastName, mapString: self.mapString, mediaURL: self.mediaUrlField.text!, latitude: self.userLat, longitude: self.userLon, completionHandler: { (success, error) -> Void in
                                if(success){
                                    print("Successful update to pin")
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        self.dismissViewControllerAnimated(false, completion: nil)
                                    })
                                }else{
                                    //Notify of bad update
                                    print("Unsuccessful update to pin")
                                }
                            })
                        }else{
                            //Use data to post
                            self.parseInstance.postStudentLocation(userId, firstName: firstName, lastName: lastName, mapString: self.mapString , mediaURL: self.mediaUrlField.text!, latitude: self.userLat, longitude: self.userLon, completionHandler: { (success, error) -> Void in
                                //TODO:
                                //Replace w/ alert views
                                if(success){
                                    print("Successful Post")
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        self.dismissViewControllerAnimated(false, completion: nil)
                                    })
                                }else{
                                    //Notify of bad post
                                    print(error)
                                }
                            })
                        }
                    }
                })
            }
        }
    }
    
    
    func zoomInLocation(placeMark: CLPlacemark){
        //Zoom in on map for desired radius
        let spanX: CLLocationDegrees = 0.00725;
        let spanY: CLLocationDegrees = 0.00725;
        var region = MKCoordinateRegion()
        region.center.latitude = placeMark.location!.coordinate.latitude
        region.center.longitude = placeMark.location!.coordinate.longitude
        
        //To be passed to Parse
        self.userLat = placeMark.location!.coordinate.latitude
        self.userLon = placeMark.location!.coordinate.longitude
        
        region.span = MKCoordinateSpanMake(spanX, spanY)
        self.mapView.setRegion(region, animated: true)
        
        //Create pin/annotation for location
        let annotation = MKPointAnnotation()
        annotation.coordinate = placeMark.location!.coordinate
        self.mapView.addAnnotation(annotation)
    }
    
    @IBAction func cancelMediaUrlPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }

}
