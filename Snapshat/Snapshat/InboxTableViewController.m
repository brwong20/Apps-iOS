//
//  InboxTableViewController.m
//  Snapshat
//
//  Created by Brian Wong on 8/25/15.
//  Copyright (c) 2015 Brian Wong. All rights reserved.
//

#import "InboxTableViewController.h"
#import "LoginViewController.h"
#import "ImageViewController.h"
#import "MSCellAccessory.h"

@interface InboxTableViewController ()

@end

@implementation InboxTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Initialize the movie player to use in didSelectRow
    self.moviePlayer = [[MPMoviePlayerController alloc]init];
    
    //Checks to see if a user is already logged in
    PFUser *currentUser = [PFUser currentUser];
    if(currentUser){
        NSLog(@"Current user:%@", currentUser.username);
    }else{
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
    
    
    //Pull to refresh implementation
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.refreshControl addTarget:self action:@selector(retrieveMessages) forControlEvents:UIControlEventValueChanged];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:NO];
    
    PFUser *currentUser = [PFUser currentUser];
    if(currentUser){
        [self retrieveMessages];
    }else{
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.messages count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InboxCell" forIndexPath:indexPath];
    
    //Configuring a cell to display a message
    PFObject *message = [self.messages objectAtIndex:indexPath.row];
    cell.textLabel.text = [message objectForKey:@"senderName"];
    
    UIColor *disclosureColor = [UIColor colorWithRed:0.553 green:0.439 blue:0.718 alpha:1.0];
    cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_DISCLOSURE_INDICATOR color:disclosureColor];
    
    //Based on the file type, set an icon
    NSString *fileType = [message objectForKey:@"fileType"];
    if([fileType isEqualToString:@"image"]){
        cell.imageView.image = [UIImage imageNamed:@"icon_image"];
    }else{
        cell.imageView.image = [UIImage imageNamed:@"icon_video"];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //Store the message clicked as a property instead of an instance so we can send it through the segue easier
    self.selectedMessage = [self.messages objectAtIndex:indexPath.row];
    NSString *fileType = [self.selectedMessage objectForKey:@"fileType"];
    
    //Check for image or video
    if([fileType isEqualToString:@"image"]){
        [self performSegueWithIdentifier:@"showImage" sender:self];
    }else{
        
        //Set up contents of movie player
        PFFile *videoFile = [self.selectedMessage objectForKey:@"file"];
        NSURL *videoUrl = [NSURL URLWithString:videoFile.url];
        self.moviePlayer.contentURL = videoUrl;
        [self.moviePlayer prepareToPlay];
        
        //Add and setup movie player as a sub-view
        [self.view addSubview:self.moviePlayer.view];
        [self.moviePlayer setFullscreen:YES animated:YES];
    }
    
    //Delete photo/video from back-end
    NSMutableArray *recipientIds = [NSMutableArray arrayWithArray:[self.selectedMessage
                                                                   objectForKey:@"recipientIds"]];
    if([recipientIds count] ==1){
        //This is the last recipient, delete the whole message object from back-end
        [self.selectedMessage deleteInBackground];
    }else{
        //This isn't the last recipient, so just remove them from the list of recipients
        [recipientIds removeObject:[[PFUser currentUser]objectId]];//From our mutable array
        
        //Create a new message object with deleted recipient on back-end
        [self.selectedMessage setObject:recipientIds forKey:@"recipientIds"];
        [self.selectedMessage saveInBackground];
    }
    
}


- (IBAction)logoutButton:(id)sender {
    //Logs out the current user and returns them to the login screen
    [PFUser logOut];
    [self performSegueWithIdentifier:@"showLogin" sender:self];
}

//Sets all View controllers after showLogin segue on the NAVIGATION STACK to not have the bottom bar tabs when shown
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    LoginViewController *lvc = segue.destinationViewController;
    if([segue.identifier isEqualToString:@"showLogin"]){
        //Gets rid of the lower bar of tabs mentioned above
        [lvc setHidesBottomBarWhenPushed:YES];
        //Hides back button so user doesn't go back into inbox after logging out
        lvc.navigationItem.hidesBackButton = YES;
    }else if([segue.identifier isEqualToString:@"showImage"]){
        [lvc setHidesBottomBarWhenPushed:YES];
        ImageViewController *imageView = (ImageViewController*) segue.destinationViewController;
        //Set the UIImageView's message to the one selected in the inbox
        imageView.message = self.selectedMessage;
    }
    
}

- (void)retrieveMessages {
    //Query the message class with current user credentials
    
    PFQuery *query = [PFQuery queryWithClassName:@"Messages"];
    
    //Find all the recipient Ids that match the current user's id (user is the recipient)
    [query whereKey:@"recipientIds" equalTo:[[PFUser currentUser] objectId]];
    [query orderByDescending:@"createdAt"];
    
    //Execute the query
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        else {
            // We found messages!
            self.messages = objects;
            [self.tableView reloadData];
        }
        //Stops pull to refresh if still refreshing
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.refreshControl isRefreshing]) {
                [self.refreshControl endRefreshing];
            }
        });
    }];
}



@end
