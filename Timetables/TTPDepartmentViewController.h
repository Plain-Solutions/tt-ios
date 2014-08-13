//
//  TTPDepartmentViewController.h
//  Timetables
//
//  Created by Vlad Selpukhin on 29/06/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MVYSideMenuController.h"
#import "TTPGroupViewController.h"
#import "MBProgressHUD.h"
#import "ViewControllerDefines.h"

#import "TTPDepartment.h"
#import "TTPParser.h"
#import "TTPSharedSettingsController.h"

/**
 Department view
 This is used to select a department both in first start and search.
 */
@interface TTPDepartmentViewController : UITableViewController <MBProgressHUDDelegate>
@end
