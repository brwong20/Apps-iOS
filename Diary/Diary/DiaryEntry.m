//
//  DiaryEntry.m
//  Diary
//
//  Created by Brian Wong on 8/21/15.
//  Copyright (c) 2015 Brian Wong. All rights reserved.
//

#import "DiaryEntry.h"


@implementation DiaryEntry

@dynamic body;
@dynamic date;
@dynamic imageData;
@dynamic location;
@dynamic mood;


//Used when intializing our fetchedResultsController in sectionNameKeyPath - this creates a header for each section based on the current date
-(NSString*)sectionName{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMM yyyy"];
    
    return [dateFormatter stringFromDate:date];
}

@end
