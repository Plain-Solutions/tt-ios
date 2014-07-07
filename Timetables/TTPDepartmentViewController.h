//
//  TTPDepartmentViewController.h
//  Timetables
//
//  Created by Vlad Selpukhin on 29/06/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewControllerDefines.h"
#import "TTPGroupViewController.h"
#import "TTPDepartment.h"
#import "TTPParser.h"

/**
 Department view
 This is used to select a department both in first start and search.
 */
@interface TTPDepartmentViewController : UITableViewController

/**
 Fetched Department list of TTPDepartment.
 */
@property (nonatomic, strong) NSMutableArray *departmentList;

/**
 Button to proceed to group selection.
 This button is unused, but there is some bug that forces us to keep it
 because without it, the app crashes.
 More: http://stackoverflow.com/questions/24598642/exception-on-coding-compilant-value-for-non-existing-button
 */
@property (nonatomic, weak) IBOutlet UIBarButtonItem *nextButton;

@end
