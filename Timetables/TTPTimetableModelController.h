//
//  TTPTimetableModelController.h
//  Timetables
//
//  Created by Vladislav Slepukhin on 23/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTPTimetableDataViewController.h"
#import "TTPTimetableAccessor.h"

#import "TTPGroup.h"
#import "TTPParser.h"


@interface TTPTimetableModelController : NSObject <UIPageViewControllerDataSource>

/**
 Passed from mater view accessor with pre-defined timetable
 */
@property (strong, nonatomic) TTPTimetableAccessor *accessor;

- (TTPTimetableDataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;

@end
