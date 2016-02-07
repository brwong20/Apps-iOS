//
//  NewEntryViewController.h
//  Diary
//
//  Created by Brian Wong on 8/20/15.
//  Copyright (c) 2015 Brian Wong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiaryEntry.h"
#import "CoreDataStack.h"
#import <CoreLocation/CoreLocation.h>


@interface EntryViewController : UIViewController

//Needed so we can edit our saved entries
@property(nonatomic,strong)DiaryEntry *entry;

-(void)insertDiaryEntry;



@end
