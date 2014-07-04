//
//  TTPTimetableViewController.h
//  Timetables
//
//  Created by Vladislav Slepukhin on 30/06/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewControllerDefines.h"
#import "TTPDepartmentViewController.h"
#import "TTPSubjectCell.h"
#import "TTPDepartment.h"
#import "TTPParser.h"
#import "TTPTimetableAccessor.h"

/**
 Main app view.
 */
@interface TTPTimetableViewController : UIViewController

/**
 Department from the last screen selection
 */
@property (nonatomic, strong) TTPDepartment *selectedDepartment;

/**
 Group from the last screen selection
 */
@property (nonatomic, strong) NSString *selectedGroup;

/**
 Lessons to display.
 */
@property (nonatomic, strong) NSMutableArray *dayLessons;

/**
 Display the name of the day.
 */
@property (weak, nonatomic) IBOutlet UILabel *daynameLabel;

/**
 Select even or odd timetable.
 */
@property (weak, nonatomic) IBOutlet UISegmentedControl *paritySelector;

/**
 Show selected (with swipes) day.
 */
@property (weak, nonatomic) IBOutlet UIPageControl *daySelector;

/**
 Display timetable
 */
@property (weak, nonatomic) IBOutlet UITableView *timetable;

- (IBAction)searchGroups:(id)sender;
@end
