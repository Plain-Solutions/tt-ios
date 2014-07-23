//
//  TTPTimetableModelController.m
//  Timetables
//
//  Created by Vladislav Slepukhin on 23/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import "TTPTimetableModelController.h"
#import "TTPTimetableDataViewController.h"
@interface TTPTimetableModelController()
@property (readonly, strong, nonatomic) NSArray *pageData;
@end

@implementation TTPTimetableModelController

- (id)init
{
    self = [super init];
    if (self) {
		// Create the data model.
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		_pageData = [[dateFormatter monthSymbols] copy];
    }
    return self;
}

- (TTPTimetableDataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard
{
    // Return the data view controller for the given index.
    if (([self.pageData count] == 0) || (index >= [self.pageData count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    TTPTimetableDataViewController *dataViewController = [storyboard instantiateViewControllerWithIdentifier:@"TimetableView"];
	dataViewController.dataObject = self.pageData[index];
    return dataViewController;
}

- (NSUInteger)indexOfViewController:(TTPTimetableDataViewController *)viewController
{
	// Return the index of the given data view controller.
	// For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
    return [self.pageData indexOfObject:viewController.dataObject];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(TTPTimetableDataViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        index = [self.pageData count];
    }
    
    index--;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(TTPTimetableDataViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageData count]) {
        return 0;
    }
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}
@end