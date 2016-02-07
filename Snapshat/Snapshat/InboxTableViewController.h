//
//  InboxTableViewController.h
//  Snapshat
//
//  Created by Brian Wong on 8/25/15.
//  Copyright (c) 2015 Brian Wong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MediaPlayer/MediaPlayer.h>

@interface InboxTableViewController : UITableViewController
@property (nonatomic, strong)NSArray *messages;
@property (nonatomic, strong)PFObject *selectedMessage;
@property (nonatomic, strong)MPMoviePlayerController *moviePlayer;
@property (nonatomic, strong)UIRefreshControl *refreshControl;

- (IBAction)logoutButton:(id)sender;

@end
