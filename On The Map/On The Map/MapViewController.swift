//
//  MapViewController.swift
//  On The Map
//
//  Created by Brian Wong on 9/14/15.
//  Copyright (c) 2015 Brian Wong. All rights reserved.
//

import UIKit
import MapKit
import FBSDKLoginKit

class MapViewController: UIViewController, MKMapViewDelegate {

    /*TODO:
            SECOND: Implement post button, logout button
            THIRD: Make it look more nice - cooler pins!
    */
    
    let udacityInstance = UdacityClient.sharedInstance()
    let parseInstance = ParseClient.sharedInstance()
    static var facebookLogin: Bool = false //Used to switch between logout buttons
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        let postImage = UIImage(named: "pin56")
        let rightPostBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: postImage!, style: UIBarButtonItemStyle.Plain, target: self, action: "postNewPinButton")
        
        let refreshImage = UIImage(named: "arrow637")
        let refreshMapBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: refreshImage!, style: UIBarButtonItemStyle.Plain, target: self, action: "refreshData")
        
        self.navigationItem.setRightBarButtonItems([rightPostBarButtonItem, refreshMapBarButtonItem], animated: true)
        
        self.refreshData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshData()
    }
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView! {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .Red
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let validURL = self.validateUrl(annotationView.annotation!.subtitle!!)
        
        if(validURL){
            if control == annotationView.rightCalloutAccessoryView {
                let app = UIApplication.sharedApplication()
                app.openURL(NSURL(string: annotationView.annotation!.subtitle!!)!)
            }
        }else{
            print("Invalid URL")
        }
    }
    
    func retrieveStudentLocations(){
        //Array of locations to set as pins
        parseInstance.getStudentLocations { (success, locations, errorString) -> Void in
            if success{
                
                var studentLocations:[[String:AnyObject]] = []
                studentLocations = locations
                
                var annotations = [MKAnnotation]()
                
                for dictionary in studentLocations{
                    // lat and long conversion
                    let lat = CLLocationDegrees(dictionary[ParseClient.JSONResponseKeys.Latitude] as! Double)
                    let long = CLLocationDegrees(dictionary[ParseClient.JSONResponseKeys.Longitude] as! Double)
                    
                    // lat and long used to create a coordinate
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    let first = dictionary[ParseClient.JSONResponseKeys.FirstName] as! String
                    let last = dictionary[ParseClient.JSONResponseKeys.LastName] as! String
                    let mediaURL = dictionary[ParseClient.JSONResponseKeys.MediaURL] as! String
                    
                    // Here we create the annotation and set its coordiate, title, and subtitle properties
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(first) \(last)"
                    annotation.subtitle = mediaURL
                    
                    // Finally we place the annotation in an array of annotations.
                    annotations.append(annotation)
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    // When the array is complete, we add the annotations to the map.
                    self.mapView.removeAnnotations(self.mapView.annotations)
                    self.mapView.addAnnotations(annotations)
                })
            }else{
                print("Error retrieving locations")
            }
        }
    }

    func postNewPinButton(){

        //Get user data
        udacityInstance.taskForGetUserData { (result, error) -> Void in
            if let userData: AnyObject  = result{
                let userDictionary = userData["user"] as! NSDictionary
                let userId = userDictionary["key"] as! String
                
                //Check for existing pin
                self.parseInstance.queryExistingLocation(userId, completionHandler: { (success, error) -> Void in
                    if let objectId = success{
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let pinAlertController = UIAlertController(title: nil, message: "You have already posted a location. Would you like to overwrite your current location?", preferredStyle: .Alert)
                            let overWriteAction = UIAlertAction(title: "Overwrite", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                                let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MapGeoCoder") 
                                self.presentViewController(controller, animated: true, completion: nil)
                            })
                            //Prompt user to overwrite
                            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:nil)
                            pinAlertController.addAction(cancelAction)
                            pinAlertController.addAction(overWriteAction)
                            self.presentViewController(pinAlertController, animated: true, completion: nil)
                        })
                    }else{
                        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MapGeoCoder") 
                        self.presentViewController(controller, animated: true, completion: nil)
                    }
                })
            }
        }
    }
    
    func refreshData(){
        self.retrieveStudentLocations()
    }
    
    @IBAction func logoutButton(sender: UIBarButtonItem) {
        if(MapViewController.facebookLogin == false){
            udacityInstance.taskForLogout()
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let loginController = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController")
                    self.presentViewController(loginController, animated: true, completion: nil)
                })
        }else{
            print("Hey")
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let loginController = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController")
                self.presentViewController(loginController, animated: true, completion: nil)
            })
        }
    }
    
    //Helper: Simple url validation function
    
    func validateUrl (stringURL : NSString) -> Bool {
        
        var urlRegEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[urlRegEx])
        var urlTest = NSPredicate.predicateWithSubstitutionVariables(predicate)
        
        return predicate.evaluateWithObject(stringURL)
    }
    
    
}