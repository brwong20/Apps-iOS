//
//  PhotoViewController.m
//  TapletTest
//
//  Created by Brian Wong on 10/3/15.
//  Copyright © 2015 Brian Wong. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UILongPressGestureRecognizer *longPress;
@property (strong, nonatomic) __block PHObjectPlaceholder *assetCollectionPlaceholder;
@property (strong, nonatomic) __block PHAssetCollection *assetCollection;
@property (strong, nonatomic) __block PHFetchResult *photoAssets;

@end

@implementation PhotoViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imageView.userInteractionEnabled = YES;
    self.longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(saveAction:)];
    self.longPress.delegate = self;
    [self.imageView addGestureRecognizer:self.longPress];
    self.imageView.image = self.screenshotImage;
}

-(void)saveAction:(UILongPressGestureRecognizer*)sender{
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Save photo?" message:@"You can save this photo in a custom album for the app!" preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            //Check for already created album
            PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
            fetchOptions.predicate = [NSPredicate predicateWithFormat:@"title = %@", @"TapletTest"];
            self.assetCollection = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                                                  subtype:PHAssetCollectionSubtypeAny
                                                                  options:fetchOptions].firstObject;
            if (!self.assetCollection) {
                [self createNewAlbum];
            }
            
            //Save photo when album exists
            [self savePhotoToCustomAlbum:self.screenshotImage];
            
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:saveAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

-(void)createNewAlbum{
    [[PHPhotoLibrary sharedPhotoLibrary]performChanges:^{
        //Create the album creation request
        PHAssetCollectionChangeRequest *createAlbumRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:@"TapletTest"];
        //Store placeholder for later
        self.assetCollectionPlaceholder = createAlbumRequest.placeholderForCreatedAssetCollection;
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        //Add to photo library
        PHFetchResult *collectionFetchResult = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[self.assetCollectionPlaceholder.localIdentifier] options:nil];
        
        //Get the first result of our collection fetch(our custom album)
        self.assetCollection = collectionFetchResult.firstObject;
    }];
}

-(void)savePhotoToCustomAlbum:(UIImage*)photo{
    [[PHPhotoLibrary sharedPhotoLibrary]performChanges:^{
        PHAssetChangeRequest *changeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:photo];
        self.assetCollectionPlaceholder = [changeRequest placeholderForCreatedAsset];
        self.photoAssets = [PHAsset fetchAssetsInAssetCollection:self.assetCollection options:nil];
        
        //Use created placeholder and retrieved assets to create a change request for custom album
        PHAssetCollectionChangeRequest *albumChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:self.assetCollection assets:self.photoAssets];
        [albumChangeRequest addAssets:@[self.assetCollectionPlaceholder]];//Add asset using the change request AND with the custom placeholder
    } completionHandler:nil];
}

@end
