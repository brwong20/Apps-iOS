//
//  EntryCell.h
//  Diary
//
//  Created by Brian Wong on 8/23/15.
//  Copyright (c) 2015 Brian Wong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiaryEntry.h"


@interface EntryCell : UITableViewCell

+(CGFloat)heightForEntry:(DiaryEntry*)entry;

-(void)configureCellForEntry:(DiaryEntry*)entry;
@end
