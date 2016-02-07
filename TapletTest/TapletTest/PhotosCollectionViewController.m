//
//  PhotosCollectionViewController.m
//  TapletTest
//
//  Created by Brian Wong on 10/3/15.
//  Copyright © 2015 Brian Wong. All rights reserved.
//

#import "PhotosCollectionViewController.h"
#import "PhotosCollectionViewCell.h"
#import "PhotoViewController.h"

@interface PhotosCollectionViewController () <UIGestureRecognizerDelegate>

@property (nonatomic,strong)UIImage *selectedImage;
@property (nonatomic,strong)UILongPressGestureRecognizer *longPress;

@end

@implementation PhotosCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //Allow user to save to custom app album
    self.longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(saveAction:)];
    self.longPress.delegate = self;
    self.longPress.minimumPressDuration = 0.7;
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.imageArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotosCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    //Set each cell's image and data
    cell.imageView.image = self.imageArray[indexPath.row];

    return cell;
}

#pragma mark <UICollectionViewDelegate>
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PhotosCollectionViewCell *cell = (PhotosCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    [cell addGestureRecognizer:self.longPress];
    
    self.selectedImage = self.imageArray[indexPath.row];
    [self performSegueWithIdentifier:@"showImage" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier]isEqualToString:@"showImage"]){
        PhotoViewController *photoVC = (PhotoViewController*) segue.destinationViewController;
        photoVC.screenshotImage = self.selectedImage;
    }
}

-(void)saveAction:(UILongPressGestureRecognizer*)sender{
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Save photo?" message:@"You can save this photo in a custom album for the app!" preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:saveAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
