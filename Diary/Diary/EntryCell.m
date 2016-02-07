//
//  EntryCell.m
//  Diary
//
//  Created by Brian Wong on 8/23/15.
//  Copyright (c) 2015 Brian Wong. All rights reserved.
//

#import "EntryCell.h"
#import <QuartzCore/QuartzCore.h>

@interface EntryCell()
@property(weak,nonatomic)IBOutlet UILabel *dateLabel;
@property(weak,nonatomic)IBOutlet UILabel *bodyLabel;
@property(weak,nonatomic)IBOutlet UILabel *locationLabel;
@property (weak, nonatomic)IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic)IBOutlet UIImageView *moodImageView;
@end

@implementation EntryCell

+(CGFloat)heightForEntry:(DiaryEntry*)entry{
    //Based on Interface Builder
    const CGFloat topMargin = 35.0f;
    const CGFloat bottomMargin = 80.0f;
    const CGFloat minHeight = 85.0f;
    
    UIFont *font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    //Creates a "bounding box" CGRect that allots the smallest area that the text will fit in. Based on: font size, text length, and leading
    //Note: OPTIONS parameters are standard - they help us format multiple lines in the label
    
    //      ATTRIBUTES are just extra properties we want for our labels (NSDictionary)
    
    //      CGSizeMake uses the width of the text label in IB, but uses CGFLOAT_MAX for the height since                 we want the box grow vertically as much as needed
    
    CGRect boundingBox = [entry.body boundingRectWithSize:CGSizeMake(245, CGFLOAT_MAX) options:(NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName: font} context:nil];
    
    //Here, we use the max function to compare which value is larger, with minHeight being the smallest value returned (default size). If the boundingBox is larger, we use that instead.
    return MAX(minHeight, CGRectGetHeight(boundingBox) + topMargin + bottomMargin);
}

-(void)configureCellForEntry:(DiaryEntry*)entry{
    self.bodyLabel.text = entry.body;
    self.locationLabel.text = entry.location;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"EEEE, MMMM d yyyy"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:entry.date];
    
    self.dateLabel.text = [dateFormatter stringFromDate:date];
    
    if(entry.imageData){
        self.mainImageView.image = [UIImage imageWithData:entry.imageData];
    }else{
        self.mainImageView.image = [UIImage imageNamed:@"icn_noimage"];
    }
    
    if(entry.mood == DiaryEntryMoodGood){
        self.moodImageView.image = [UIImage imageNamed:@"icn_happy"];
    }else if(entry.mood == DiaryEntryMoodBad){
        self.moodImageView.image = [UIImage imageNamed:@"icn_bad"];
    }else if(entry.mood == DiaryEntryMoodAverage){
        self.moodImageView.image = [UIImage imageNamed:@"icn_average"];
    }
    
    if(entry.location.length > 0){
        self.locationLabel.text = entry.location;
    }else{
        self.locationLabel.text = @"No Location";
    }
    
    //Rounds out buttons corners
    self.mainImageView.layer.cornerRadius = CGRectGetWidth(self.mainImageView.frame)/2.0f;
}

@end

