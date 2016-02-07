//
//  FriendsViewController.m
//  Snapshat
//
//  Created by Brian Wong on 8/20/15.
//  Copyright (c) 2015 Brian Wong. All rights reserved.
//

#import "FriendsViewController.h"
#import "EditFriendsTableViewController.h"
#import <Parse/Parse.h>
#import "GravatarUrlBuilder.h"

@interface FriendsViewController ()

@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //Gets relation column of data - want to set it here so it refreshes whenever you switch to the view
    self.friendRelation = [[PFUser currentUser]objectForKey:@"friendsRelation"];
    
    //Queries it and sort by username
    PFQuery *query = [[self.friendRelation query]orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if(error){
            NSLog(@"Error : %@ %@", error, [error userInfo]);
        }else{
            self.friends = objects;
            [self.tableView reloadData];
        }
    }];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"showEdit"]){
        EditFriendsTableViewController *viewController = (EditFriendsTableViewController *) segue.destinationViewController;
        
        viewController.friends = [NSMutableArray arrayWithArray:self.friends];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.friends count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.detailTextLabel.hidden = YES;
    
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    cell.textLabel.text = [user username];
    
    //Gravatar implementation on background thread
    
    //Queue creation
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        //1.Get email addresses
        NSString *email = [user objectForKey:@"email"];
        
        //2.Create md5 hashes - we use a pre-defined class (GravatarURLBuilder) for this
        NSURL *gravatarURL = [GravatarUrlBuilder getGravatarUrl:email];
        
        //3.Request image from Gravatar using md5 hash
        NSData *imageData = [NSData dataWithContentsOfURL:gravatarURL];
        
        //If we retrieved image data, set it on the main thread
        if(imageData != nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                //4.Set cell image
                cell.imageView.image = [UIImage imageWithData:imageData];
                //Forces each cell to be redrawn
                [cell setNeedsLayout];
            });
        }
    });
    
    //If we didn't set an image, use a default image
    cell.imageView.image = [UIImage imageNamed:@"icon_person"];
    
    return cell;
}

//Shows extra details of friends when clicked
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *firstName = [user objectForKey:@"firstName"];
    NSString *lastName = [user objectForKey:@"lastName"];
    NSString *hometown = [user objectForKey:@"hometown"];
    
    NSString *userDetails = [NSString stringWithFormat:@"%@ %@ - %@", firstName, lastName, hometown];
    
    if(cell.detailTextLabel.hidden==YES){
        cell.detailTextLabel.hidden = NO;
        cell.detailTextLabel.text = userDetails;
    }else{
        cell.detailTextLabel.hidden = YES;
    }
    
    
}


@end
