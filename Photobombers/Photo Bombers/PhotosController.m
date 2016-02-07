//
//  PhotosController.m
//  Photo Bombers
//
//  Created by Brian Wong on 8/15/15.
//  Copyright (c) 2015 Brian Wong. All rights reserved.
//

#import "PhotosController.h"
#import <SAMCache/SAMCache.h>

@implementation PhotosController

//Refactored method to retrieve a photo from the cache or network - We are passing in: the dictionary of photo data, the desired size, and a block to signal if our photo was retrieved or not (completion block)

//BLOCKS are the BEST WAY to execute EXTERNAL code (code after a network call completes) within a method once a network call has been completed!

+ (void)imageForPhoto:(NSDictionary*)photo size:(NSString*)size completion:(void(^)(UIImage* image))completion{
    
    //Simple check to prevent crash
    if(photo == nil || size == nil || completion == nil){
        return;
    }
    
    //Set up a key to identify our photos - we use their ids and size
    NSString *key = [[NSString alloc]initWithFormat:@"%@-%@", photo[@"id"], size];
    //We try to retrieve our photo from the cache
    UIImage *image = [[SAMCache sharedCache]imageForKey:key];
    //If the photo exists, we will use it and skip the code below. If it doesn't ,we will cache it below.
    if(image){
        //Calls the block and uses the image we retrieve from the cache
        
        //BLOCKS ARE CALLED JUST LIKE FUNCTIONS IN THIS CASE (AS METHOD PARAMETERS) AND WE PASS IN THE SPECIFIED PARAMETER (UIIMAGE) THE BLOCK WANTS. AFTER, WHATEVER CODE IS IN THE BLOCK WE CREATE WHEN USED, THE BLOCK USES THIS PARAMETER WITHIN THE {CODE}
        completion(image);
        return;
    }
    
    NSURL *url = [[NSURL alloc]initWithString:photo[@"images"][size][@"url"]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        
        NSData *data = [[NSData alloc]initWithContentsOfURL:location];
        UIImage *image = [[UIImage alloc]initWithData:data];
        
        //Cache the photo we just initialized so we don't have to download each time we refresh our collection view
        [[SAMCache sharedCache]setImage:image forKey:key];
        
        //Runs UIImage update on MAIN THREAD - where UI updates should always happen
        //Since these updates are on the main thread, they happen right away each time image data is available
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(image);
        });
    }];
    [task resume];

}

@end
