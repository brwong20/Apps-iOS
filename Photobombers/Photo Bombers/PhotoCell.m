//
//  PhotoCell.m
//  Photo Bombers
//
//  Created by Brian Wong on 8/4/15.
//  Copyright (c) 2015 Brian Wong. All rights reserved.
//

#import "PhotoCell.h"
#import "PhotosController.h"

@implementation PhotoCell
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.cellPhoto = [[UIImageView alloc]init];
        
        //Adds a gesture recognizer to each photo cell
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector((like:))];
        
        tap.numberOfTapsRequired = 2;
        
        [self addGestureRecognizer:tap];
        
        [self.contentView addSubview:self.cellPhoto];
    }
    return self;
}


//Customization for each UIImageView in our cell
-(void)layoutSubviews{
    [super layoutSubviews];
    
    //Sets the size of the image to the bounds of the cell(fills the cell)
    self.cellPhoto.frame = self.contentView.bounds;
}


//Overriding the setter method which is called every time something like cell.photo is called
//We download a photo with a url now instead of just explicity setting it
-(void)setPhoto:(NSDictionary *)photo{
    _photo = photo;
    
    
    //Calls the convenience method we made in PhotosController and uses our dictionary of photos, a desired size, and updates that photo with the image passed into the completion block
    [PhotosController imageForPhoto:_photo size:@"thumbnail" completion:^(UIImage *image) {
        //Because our block RETURNS VOID, we can just set the image
        self.cellPhoto.image = image;
    }];
}

-(void)like:(id)sender{
    
    //Long press to like a photo
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    if (longPress.state == UIGestureRecognizerStateEnded) {
        NSURLSession *session = [NSURLSession sharedSession];
        NSString *accessToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"accessToken"];
        
        //API to like a photo
        NSString *urlString = [[NSString alloc]initWithFormat:@"https://api.instagram.com/v1/media/%@/likes?access_token=%@", self.photo[@"id"], accessToken];
        NSURL *url = [[NSURL alloc]initWithString:urlString];
        
        //A MUTABLE URL request allows us to do more than simply get the URL and load it (set properties,etc)
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
        
        //Since POST is the method to create things, we are techincally creating likes with it here
        request.HTTPMethod = @"POST";
        
        //Since we don't need to download data like with SessionDownloadTask, we use DataTask instead
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            //Only executes after our request to like a photo has completed
            //We tell the instagram API what to do, it tells us its done, we get the main thread to signal completion! aka Asynchronous Networking!
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showLikeCompletion];
            });
        }];
        [task resume];
    }
}


-(void) showLikeCompletion{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Liked!" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [alertView show];
    
    //Dispatches the code to dismiss the alert view on the MAIN thread after a delay
    double delayInSeconds = 1.0;
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds*NSEC_PER_SEC));
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    });
}
    


@end
