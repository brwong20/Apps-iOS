//
//  PhotosViewController.m
//  Photo Bombers
//
//  Created by Brian Wong on 8/4/15.
//  Copyright (c) 2015 Brian Wong. All rights reserved.
//

#import "PhotosViewController.h"
#import "PhotoCell.h"
#import "DetailViewController.h"
#import "PresentDetailTransition.h"
#import "DismissDetailTransition.h"
#import "THMetadataView.h"
#import "IntroViewController.h"


#import <SimpleAuth/SimpleAuth.h>


//Class extension : Everything in the interface is private and unique to this class
@interface PhotosViewController()<UIViewControllerTransitioningDelegate>
@property (nonatomic,strong) NSArray *photos;
@property (nonatomic) UIRefreshControl *refreshControl;
@end


//Implementation is done w/o Interface Builder
@implementation PhotosViewController

//Custom init method that's called whenever we create a new PhotoVC
-(instancetype) init{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    
    //Layout parameters
    layout.itemSize = CGSizeMake(124.0, 124.0);
    layout.minimumInteritemSpacing = 1;
    layout.minimumLineSpacing = 1;
    
    return (self = [super initWithCollectionViewLayout:layout]);
    
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    //If no hashtag was entered
    if(self.hashtag == nil){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"You didn't enter any hashtag to search!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }
    
    //Sets title of nav bar
    if(self.hashtag != nil){
        self.title = [[NSString alloc]initWithFormat:@"#%@", self.hashtag];
    }else{
        self.title = @"#tryagain";
    }


    //Gets rid of white space under nav bar
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //"Back"/Search again Button
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style: UIBarButtonItemStylePlain target:self action:@selector(backButton)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc]initWithTitle:@"Log out" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
    self.navigationItem.rightBarButtonItem = logoutButton;
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    //Instead of connecting the "prototype cell" in storyboard, we use this method to connect our cells to our custom photo viewing class
    [self.collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:@"photo"];
    
    //Swipe to refresh photos
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.refreshControl addTarget:self action:@selector(swipeToReloadPhotos) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:self.refreshControl];
    self.collectionView.alwaysBounceVertical = YES;
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.accessToken = [userDefaults objectForKey:@"accessToken"];
    
    //If the user isn't logged in (they have no token), tell them to sign in and save one
    
    if(self.accessToken == nil) {
        //Allows user to authorize and integrate instagram in our app - returns a unique token
        //ALSO NOTICE: We added a scope key with an array of values - these values allow us to authorize the user to use instagram's different functions. The one we use here is the like feature we use in PhotoCell
        [SimpleAuth authorize:@"instagram" options:@{@"scope": @[@"likes"]} completion:^(NSDictionary *responseObject, NSError *error) {
            
            //Retrieves the access token in the credentials key and getting the value in a concise way
            self.accessToken = responseObject[@"credentials"][@"token"];
            
            //Saves the user's token persistently on disk for use throughout our app
            [userDefaults setObject:self.accessToken forKey:@"accessToken"];
            [userDefaults synchronize];//Save
            
            //Retrieve the photos
            [self refreshPhotos];
        }];
    }else{
        [self refreshPhotos];
    }
}

- (void)backButton
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)logout{
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        NSString* domainName = [cookie domain];
        NSRange domainRange = [domainName rangeOfString:@"instagram"];
        if(domainRange.length > 0)
        {
            [storage deleteCookie:cookie];
        }
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //If the user isn't logged in (they have no token), tell them to sign in and save one
    
    
        //Allows user to authorize and integrate instagram in our app - returns a unique token
        //ALSO NOTICE: We added a scope key with an array of values - these values allow us to authorize the user to use instagram's different functions. The one we use here is the like feature we use in PhotoCell
        [SimpleAuth authorize:@"instagram" options:@{@"scope": @[@"likes"]} completion:^(NSDictionary *responseObject, NSError *error) {
            
            //Retrieves the access token in the credentials key and getting the value in a concise way
            //self.accessToken = responseObject[@"credentials"][@"token"];
            
            //Saves the user's token persistently on disk for use throughout our app
            [userDefaults removeObjectForKey:@"accessToken"];
            [userDefaults synchronize];//Save

        }];
    
}

//To implement status bar
- (void) viewDidLayoutSubviews {
    CGRect viewBounds = self.view.bounds;
    CGFloat topBarOffset = self.topLayoutGuide.length;
    viewBounds.origin.y = topBarOffset * -1;
    self.view.bounds = viewBounds;
    
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];

}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.photos count];
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photo" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor lightGrayColor];
    
    //Retrieves the photo url for the respective cell in the JSON dictionary AND calls our custom setter for the PhotoCell to use the url and download the image 
    cell.photo = self.photos[indexPath.row];
    
//    NSIndexPath *lastCell = [NSIndexPath index
//    UICollectionViewCell *backButtonCell = [self collectionView:collectionView cellForItemAtIndexPath:lastCell];
//    [backButtonCell.contentView addSubview:backButton];
    
    return cell;
}

- (void)refreshPhotos{
    
    //Only run URLRequest with a hashtag
    if(self.hashtag == nil){
        NSLog(@"Do nothing!");
    }else{
        //Retrieve recent photo data
        NSURLSession *session = [NSURLSession sharedSession];
        
        //Using instagram's predefined link, we can pull up all recent posts by specifying the tag after "tags/" and by entering our access token at the end
        NSString *urlString = [[NSString alloc]initWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?access_token=%@", self.hashtag, self.accessToken];
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
        
        //By creating a request and forming a download task, we can retrieve all images(data) with the tags specificed above
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            
            //Just to hold raw JSON data
            NSData *data = [[NSData alloc]initWithContentsOfURL:location];
            
            //Creates a dictionary of parsed and formatted JSON data for us to work with
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options: kNilOptions error:nil];
            
            //Updates our database (data source) with the most recent data so we can display our data each the view refreshes/loads - this is because UICollectionView cannot tell when data is empty or has changed.
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
            
            //Returns all the urls for the specified path(specific value) in our dictionary.
            self.photos = [responseDictionary valueForKey:@"data"];
            
        }];
        [task resume];//Start the download task
    }
}


-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
    //Retrieves photo data based on item clicked and passes to detail view
    NSDictionary *photo = self.photos[indexPath.row];
    DetailViewController *detailView = [[DetailViewController alloc]init];
    
    //Going to present the detail view modally with a custom animation
    detailView.modalPresentationStyle = UIModalPresentationCustom;
    
    //Tells who is performing the transition which allows us to initialize the presenting and dismissing animations for this view to actually perform the transition
    detailView.transitioningDelegate = self;
    detailView.photo = photo;
    
    [self presentViewController:detailView animated:YES completion:nil];
    
}

-(void)swipeToReloadPhotos{
    [self refreshPhotos];
    [self.refreshControl endRefreshing];
}

//Initialize animation in here for protocol required method
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [[PresentDetailTransition alloc]init];
}

//Initialize dismisssal animation here for protocol 
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [[DismissDetailTransition alloc]init];
}






@end
