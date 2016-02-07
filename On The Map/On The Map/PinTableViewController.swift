//
//  PinTableViewController.swift
//  On The Map
//
//  Created by Brian Wong on 9/14/15.
//  Copyright (c) 2015 Brian Wong. All rights reserved.
//

import UIKit

class PinTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var tableView: UITableView!
    let udacityInstance = UdacityClient.sharedInstance()
    let parseInstance = ParseClient.sharedInstance()
    var students:[ParseStudent] = []
    
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
        students = ParseStudent.students
        
        let postImage = UIImage(named: "pin56")
        let rightPostBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: postImage!, style: UIBarButtonItemStyle.Plain, target: self, action: "postNewPinButton")
        
        let refreshImage = UIImage(named: "arrow637")
        let refreshMapBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: refreshImage!, style: UIBarButtonItemStyle.Plain, target: self, action: "refreshData")
        
        self.navigationItem.setRightBarButtonItems([rightPostBarButtonItem, refreshMapBarButtonItem], animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        students = ParseStudent.students
        self.refreshData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PinCell", forIndexPath: indexPath) 
        
        let student = students[indexPath.row]
        cell.textLabel?.text = "\(student.firstName!) \(student.lastName!)"
        cell.detailTextLabel?.text = student.mediaURL
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let mediaURL = tableView.cellForRowAtIndexPath(indexPath)?.detailTextLabel?.text
        
        let validURL = self.validateUrl(mediaURL!)
        
        if(validURL){
            let app = UIApplication.sharedApplication()
            app.openURL(NSURL(string: mediaURL!)!)
        }else{
            print("Invalid URL")
        }
    }
    
    func postNewPinButton(){
        udacityInstance.taskForGetUserData { (result, error) -> Void in
            if let userData: AnyObject  = result{
                let userDictionary = userData["user"] as! NSDictionary
                let firstName = userDictionary["first_name"] as! String
                let lastName = userDictionary["last_name"] as! String
                print("\(firstName) \(lastName)")
            }
        }
        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MapGeoCoder") 
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    func refreshData(){
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })
    }
    
    //Helper: Simple url validation function
    
    func validateUrl (stringURL : NSString) -> Bool {
        
        let urlRegEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[urlRegEx])
        var urlTest = NSPredicate.predicateWithSubstitutionVariables(predicate)
        
        return predicate.evaluateWithObject(stringURL)
    }
}
