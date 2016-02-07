//
//  CameraViewController.m
//  Snapshat
//
//  Created by Brian Wong on 8/20/15.
//  Copyright (c) 2015 Brian Wong. All rights reserved.
//

#import "CameraViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "MSCellAccessory.h"

@interface CameraViewController ()

@end

@implementation CameraViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.recipients = [[NSMutableArray alloc]init];
    self.disclosureColor = [UIColor colorWithRed:0.553 green:0.439 blue:0.718 alpha:1.0];
}

//Re-uses our EXISTING view controller each time the tab is selected

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
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
    
    //The if checks if the image picker already has a video or picture - this means the reset method wasn't called b/c the back-end failed to save the file. Because of this, our user's data can be saved and sent again, otherwise, just set up an imagePicker to choose or take a photo.
    if(self.image == nil && [self.videoFilePath length] == 0){
        self.imagePicker = [[UIImagePickerController alloc]init];
        self.imagePicker.delegate = self;
        self.imagePicker.allowsEditing = NO;
        self.imagePicker.videoMaximumDuration = 10;
        
        //If the default camera is available, use it, otherwise, use the default photo album
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }else{
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        self.imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.imagePicker.sourceType];
        
        [self presentViewController:self.imagePicker animated:NO completion:nil];
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
    
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    
    //Visual bug: Since our cells are re-used, checkmarks are too. This checks to see if our list of recipients is actually part of our list(mutable array) and not a re-used cell
    if([self.recipients containsObject:user.objectId]){
        cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_CHECKMARK color:self.disclosureColor];
    }else{
        cell.accessoryView = nil;

    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    
    //If checked, we add a PFUser recipient to our mutable array
    if(cell.accessoryView == nil){
        cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_CHECKMARK color:self.disclosureColor];
        [self.recipients addObject:user.objectId];
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessoryView = nil;
    }
}



#pragma mark - Image Picker Controller Delegate

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:NO completion:nil];
    
    [self.tabBarController setSelectedIndex:0];
}

//Called when a photo/video is taken
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    //We have to nest the mediaType because it is a CFString, not NSString
    if([mediaType isEqualToString:(NSString*) kUTTypeImage]){
        self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        //If this image was picked (taken) with the camera, save it
        if(self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera){
            UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil);
        }
    }else{
        //A video was selected - get it's URL and convert it into a path in the form of an NSString
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        self.videoFilePath = [videoURL path];
        //Save video
        if(self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera){
            //Recommended check
            if(UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(self.videoFilePath)){
                UISaveVideoAtPathToSavedPhotosAlbum(self.videoFilePath, nil, nil, nil);
            }
        }
    }
    
    //Dismiss the camera
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - IBActions


- (IBAction)cancelButton:(id)sender {
    [self reset];
    //Sends user back to inbox
    [self.tabBarController setSelectedIndex:0];
}

- (IBAction)sendButton:(id)sender {
    
    //If not image or video, ask user to try again and present camera
    if(self.image == nil && [self.videoFilePath length] == 0){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Try again!" message:@"Try taking that beautiful photo or video one more time :]" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alertView show];
        [self presentViewController:self.imagePicker animated:NO completion:nil];
    }else{
        //Send message and reset for next image/video + recipients
        [self uploadMessage];
        [self.tabBarController setSelectedIndex:0];
    }
}

#pragma mark - Helper Methods

-(void) uploadMessage{
    //Parameters needed to create a new file
    NSData *fileData;
    NSString *fileName;
    NSString *fileType;
    
    if(self.image != nil){
        UIImage *newImage = [self resizeImage:self.image toWidth:320.0f andHeight:480.0f];
        fileData = UIImagePNGRepresentation(newImage);
        fileName = @"image.png";
        fileType = @"image";
    }else{
        fileData = [NSData dataWithContentsOfFile:self.videoFilePath];
        fileName = @"video.mov";
        fileType = @"video";
    }
    
    //MBProgressHUD *sendProgress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //sendProgress.labelText = @"Sending message...";
    
    //Creating the file (subclass of PFObject)
    PFFile *file = [PFFile fileWithName:fileName data:fileData];
    
    //Saving the file to Parse
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if(error){
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Uh oh..." message:@"Please try sending that again! :[" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
        }else{
            
            //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            //Creates a new class on back-end
            PFObject *message = [PFObject objectWithClassName:@"Messages"];
            
            //Creates fields in Messsages class for relevant message data
            [message setObject:file forKey:@"file"];
            [message setObject:fileType forKey:@"fileType"];
            [message setObject:self.recipients forKey:@"recipientIds"];
            [message setObject:[[PFUser currentUser]objectId] forKey:@"senderId"];
            [message setObject:[[PFUser currentUser]username] forKey:@"senderName"];
            [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                if(error){
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Sorry about this..." message:@"There was an error in sending your file. Don't worry, we've saved your data and recipients for you. Please try sending it again. :]" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alertView show];
                }else{
                    //Send was successful! Reset the file/recipients for next message, while also preserving the data if the back-end failed to save the file
                    
                    [self reset];
                }
            }];
        }
    }];
}

-(UIImage*) resizeImage:(UIImage*)image toWidth:(float)width andHeight:(float)height{
    CGSize newSize = CGSizeMake(width, height);
    CGRect newRectangle = CGRectMake(0, 0, width, height);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:newRectangle];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

- (void)reset {
    //Clears our saved image/video and recipients
    self.image = nil;
    self.videoFilePath = nil;
    [self.recipients removeAllObjects];
}

@end
