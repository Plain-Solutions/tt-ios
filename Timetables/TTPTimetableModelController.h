//
//  TTPTimetableModelController.h
//  Timetables
//
//  Created by Vladislav Slepukhin on 23/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTPTimetableDataViewController.h"

@interface TTPTimetableModelController : NSObject <UIPageViewControllerDataSource>
- (TTPTimetableDataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(TTPTimetableDataViewController *)viewController;
@end
