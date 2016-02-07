//
//  DiaryEntry.h
//  Diary
//
//  Created by Brian Wong on 8/21/15.
//  Copyright (c) 2015 Brian Wong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

//Declaration for enums - constants we can use in place of magic numbers
typedef NS_ENUM(int16_t, DiaryEntryMood) {
    DiaryEntryMoodGood = 0,
    DiaryEntryMoodBad = 1,
    DiaryEntryMoodAverage = 2
};

@interface DiaryEntry : NSManagedObject

@property (nonatomic, retain) NSString * body;
@property (nonatomic) NSTimeInterval date;
@property (nonatomic, retain) NSData * imageData;
@property (nonatomic, retain) NSString * location;
@property (nonatomic) int16_t mood;
@property (nonatomic,readonly) NSString *sectionName;

@end
