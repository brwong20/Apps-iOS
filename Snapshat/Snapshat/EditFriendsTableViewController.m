//
//  EditFriendsTableViewController.m
//  Snapshat
//
//  Created by Brian Wong on 8/20/15.
//  Copyright (c) 2015 Brian Wong. All rights reserved.
//

#import "EditFriendsTableViewController.h"
#import "MSCellAccessory.h"

@interface EditFriendsTableViewController ()

@end

@implementation EditFriendsTableViewController

//Init in viewDidLoad since we are going to use this multiple times in this class (Global variable)


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    PFQuery *query = [PFUser query]; //Queries the entire user class
    [query orderByAscending:@"username"];//Organization of queried users (friends)
    
    //Running the query
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if(error){
            NSLog(@"Error: %@  %@", error, [error userInfo]);
        }else{
            //If PFQuery succeeds, we will store all our objects (PFUsers} as a property
            self.allUsers = objects;
            //Reloads the data since the sequential methods finish first and asynchronous data retrieval happens after - basically forces TableView and cells to be redrawn with our data
            [self.tableView reloadData];
        }
    }];
    
    //Sets current user property
    self.currentUser = [PFUser currentUser];
    
    self.disclosureColor = [UIColor colorWithRed:0.553 green:0.439 blue:0.718 alpha:1.0];
    
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.allUsers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    PFUser *user = [self.allUsers objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    
    if([self isFriend:user]){
        cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_CHECKMARK color:self.disclosureColor];
    }else{
        cell.accessoryView = nil;
    }
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //When selecting a cell, it stays highlighted - this allows it to turn the highlight off right after we select it
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    //Gets an instance of a cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    //Uses a relation object we create for us to relate friends
    PFRelation *friendsRelation = [self.currentUser relationForKey:@"friendsRelation"];
    
    //Gets current user at selected cell
    PFUser *user = [self.allUsers objectAtIndex:indexPath.row];
    
    if([self isFriend:user]){
        //Remove the check mark
        cell.accessoryView = nil;
        
        //If a friend is tapped again after they have been added, remove them from our array of friends
        for(PFUser *friend in self.friends){
            if ([friend.objectId isEqualToString:user.objectId]){
                [self.friends removeObject:friend];
                break;
            }
        }
        //After, we remove user from Parse back-end (exact opposite of code in else statement
        [friendsRelation removeObject:user];
    }else{
        //Using the array of users we pull from the back-end , we can now add them in RELATION to the current user
        cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_CHECKMARK color:self.disclosureColor];
        [self.friends addObject:user];
        [friendsRelation addObject:user];
        
    }
    
    //By saving the current user, we also save all changes to that user before this call (i.e Relation data)
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if(error){
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

#pragma mark - Helper Methods

-(BOOL)isFriend:(PFUser *)user{
    //Goes through our friends array passed from FriendsViewController
    for(PFUser *friend in self.friends){
        //Checks to see if user passed in is a friend through matching ids (strings)
        if ([friend.objectId isEqualToString:user.objectId]){
            return YES;
        }
    }
    return NO;
    
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
