//
//  NewEntryViewController.m
//  Diary
//
//  Created by Brian Wong on 8/20/15.
//  Copyright (c) 2015 Brian Wong. All rights reserved.
//

#import "EntryViewController.h"


@interface EntryViewController () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate, UITextViewDelegate>


@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) UIImage *pickedImage;
@property (nonatomic, assign) DiaryEntryMood pickedMood;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *charactersLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIButton *badButton;
@property (weak, nonatomic) IBOutlet UIButton *averageButton;
@property (weak, nonatomic) IBOutlet UIButton *goodButton;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;

//Allows us to use as keyboard accessory by overlaying
@property (strong, nonatomic) IBOutlet UIView *accessoryView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;


@end

@implementation EntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Need protocol to implement character count for text view
    self.textView.delegate = self;
    
    //Sets accessory on top of keyboard to input text and to pick a mood
    self.textView.inputAccessoryView = self.accessoryView;
    
    //Rounds out buttons corners
    self.imageButton.layer.cornerRadius = CGRectGetWidth(self.imageButton.frame)/2.0f;
    
    NSDate *date;
    
    //If we reach here because of the entry passed by the segue, set the text to the current text of the entry
    if(self.entry != nil){
        self.textView.text = self.entry.body;
        self.pickedMood = self.entry.mood;
        //Original date of entry
        date = [NSDate dateWithTimeIntervalSince1970:self.entry.date];
        //Sets image
        [self setPickedImage:[UIImage imageWithData:self.entry.imageData]];
        self.locationLabel.text = self.entry.location;
    }else{
        self.pickedMood = DiaryEntryMoodGood;
        //Current date
        date = [NSDate date];
        [self loadLocation];
        self.locationLabel.text = self.location;
    }
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEEE MMMM, d yyyy"];
    self.dateLabel.text = [formatter stringFromDate:date];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.textView becomeFirstResponder];
}

-(void)dismissSelf{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)insertDiaryEntry{
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    
    //Inserts a new managed object for an entitity name which is used to define each cell(diary entry)
    DiaryEntry *diaryEntry = [NSEntityDescription insertNewObjectForEntityForName:@"DiaryEntry" inManagedObjectContext:coreDataStack.managedObjectContext];
    diaryEntry.body = self.textView.text;
    diaryEntry.date = [[NSDate date]timeIntervalSince1970];
    diaryEntry.mood = self.pickedMood;
    diaryEntry.imageData = UIImageJPEGRepresentation(self.pickedImage, 0.75); //Converts image into imageData to store
    diaryEntry.location = self.location;//Location is only retrieved and set once when inserting
    [coreDataStack saveContext];
}

//Update the entry and persist the data
-(void)updateDiaryEntry{
    self.entry.body = self.textView.text;
    self.entry.mood = self.pickedMood;
    self.entry.imageData = UIImageJPEGRepresentation(self.pickedImage, 0.75);
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    [coreDataStack saveContext];
}
-(void)promptForSource{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Image Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Photo Roll", nil];
    
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex!=actionSheet.cancelButtonIndex){//User didn't press cancel
        //If they didnt press the first button (Photo Roll in the otherButtonTitles)
        if (buttonIndex != actionSheet.firstOtherButtonIndex) {
            [self promptForPhotoRoll];
        }else{
            [self promptForCamera];
        }
    }
}

-(void)promptForCamera{
    UIImagePickerController *controller = [[UIImagePickerController alloc]init];
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

-(void)promptForPhotoRoll{
    UIImagePickerController *controller = [[UIImagePickerController alloc]init];
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
    
}

//Retrieves a photo when picked
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //Info is stored as an NSDictionary which contains many different attributes the picked photo can have - we just want the original photo
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.pickedImage = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

//To "animate" the mood choices when picked
-(void)setPickedMood:(DiaryEntryMood)pickedMood{
    _pickedMood = pickedMood;
    
    self.badButton.alpha = 0.5f;
    self.averageButton.alpha = 0.5f;
    self.goodButton.alpha = 0.5f;
    
    switch (pickedMood) {
        case DiaryEntryMoodBad:
            self.badButton.alpha = 1.0f;
            break;
        case DiaryEntryMoodAverage:
            self.averageButton.alpha = 1.0f;
            break;
        case DiaryEntryMoodGood:
            self.goodButton.alpha = 1.0f;
        default:
            break;
    }
}

//Sets our image button based on if an image exists or not
-(void)setPickedImage:(UIImage *)pickedImage{
    _pickedImage = pickedImage;
    
    if (pickedImage == nil) {
        [self.imageButton setImage:[UIImage imageNamed:@"icn_noimage"] forState:UIControlStateNormal];
    }else{
        [self.imageButton setImage:pickedImage forState:UIControlStateNormal];
    }
}

-(void)loadLocation{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate=self;
    self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    self.locationManager.distanceFilter=kCLDistanceFilterNone;
    
    //Requests authorization to get location
    [self.locationManager requestWhenInUseAuthorization];
    
    //Starts location updates
    [self.locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    //Stops updating location to conserve battery
    [self.locationManager stopUpdatingLocation];
    
    CLLocation *location = [locations firstObject]; //Gets the first location out of all the updated locations
    
    //Reverse geocodes CLLocation to retrieve name
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks firstObject];
        self.location = placemark.name;
    }];
}

//Method to check if the textView has 200 characters or not, if it doesn't we allow the user to keep typing
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([text length] == 0)
    {
        if([textView.text length] != 0)
        {
            return YES;
        }
    }
    else if([[textView text] length] > 199)
    {
        return NO;
    }
    return YES;
}

//Counts the remaining characters the user has
-(void)textViewDidChange:(UITextView *)textView
{
    int len = (int)textView.text.length;
    self.charactersLabel.text=[NSString stringWithFormat:@"Characters remaining: %i",200-len];
}

//Done button can either complete an edit or add a new entry
- (IBAction)doneWasPressed:(id)sender {
    if(self.entry != nil){
        [self updateDiaryEntry];
    }else{
        [self insertDiaryEntry];
    }
    [self dismissSelf];
}



- (IBAction)cancelWasPressed:(id)sender {
    [self dismissSelf];
}

//Uses assign property to assign enum on button press
- (IBAction)badWasPressed:(id)sender {
    self.pickedMood = DiaryEntryMoodBad;
}

- (IBAction)averageWasPressed:(id)sender {
    self.pickedMood = DiaryEntryMoodAverage;
}

- (IBAction)goodWasPressed:(id)sender {
    self.pickedMood = DiaryEntryMoodGood;
}

- (IBAction)imageButtonWasPressed:(id)sender {
    //If the default camera is available
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [self promptForSource];
    }else{
        [self promptForPhotoRoll];
    }
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
