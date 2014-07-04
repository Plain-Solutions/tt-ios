//
//  TTPSubjectDetailViewController.h
//  Timetables
//
//  Created by Vladislav Slepukhin on 04/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTPLesson.h"
#import "TTPTimetableAccessor.h"

@interface TTPSubjectDetailViewController : UIViewController
@property (nonatomic, strong) TTPLesson *selectedLesson;
@property (nonatomic, assign) TTPTimetableAccessor *accessor;
@end
