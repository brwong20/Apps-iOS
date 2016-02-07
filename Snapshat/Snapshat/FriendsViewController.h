//
//  FriendsViewController.h
//  Snapshat
//
//  Created by Brian Wong on 8/20/15.
//  Copyright (c) 2015 Brian Wong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface FriendsViewController : UITableViewController

@property (strong, nonatomic) PFRelation *friendRelation;
@property (strong, nonatomic) NSArray *friends;

@end
