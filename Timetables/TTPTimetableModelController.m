//
//  TTPTimetableModelController.m
//  Timetables
//
//  Created by Vladislav Slepukhin on 23/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import "TTPTimetableModelController.h"

@interface TTPTimetableModelController()
@end


@implementation TTPTimetableModelController


- (TTPTimetableDataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard
{
	// Create a new view controller and pass suitable data.
    TTPTimetableDataViewController *dataViewController = [storyboard instantiateViewControllerWithIdentifier:@"TimetableView"];
	dataViewController.day = index;
	dataViewController.accessor = self.accessor;
    return dataViewController;
}


- (NSUInteger)indexOfViewController:(TTPTimetableDataViewController *)viewController
{
	[viewController.table scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];

    return viewController.day;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
	return [self viewControllerAtIndex:[self.accessor previousDay:[self indexOfViewController:(TTPTimetableDataViewController *)viewController]].day
							storyboard:viewController.storyboard];

}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{

	return [self viewControllerAtIndex:[self.accessor nextDay:[self indexOfViewController:(TTPTimetableDataViewController *)viewController]].day
							storyboard:viewController.storyboard];

}
@end