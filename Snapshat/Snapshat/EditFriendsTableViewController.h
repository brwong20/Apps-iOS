//
//  EditFriendsTableViewController.h
//  Snapshat
//
//  Created by Brian Wong on 8/20/15.
//  Copyright (c) 2015 Brian Wong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface EditFriendsTableViewController : UITableViewController

@property (strong,nonatomic) NSArray *allUsers;
@property (strong,nonatomic) PFUser *currentUser;
@property (strong, nonatomic) PFRelation *friendRelation;
@property (nonatomic, strong)UIColor *disclosureColor;

//Allows us to filter who's our friend and allots checkmarks for those who are
@property (strong,nonatomic) NSMutableArray *friends;

-(BOOL)isFriend:(PFUser *)user;

@end
