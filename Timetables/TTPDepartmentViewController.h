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

@end
