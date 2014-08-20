//
//  TTPGroupViewController.h
//  Timetables
//
//  Created by Vlad Selpukhin on 29/06/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TTPMenuViewController.h"
#import "TTPMainViewController.h"
#import "ViewControllerDefines.h"
#import "MVYSideMenuController.h"
#import "MBProgressHUD.h"

#import "TTPDepartment.h"
#import "TTPParser.h"
#import "TTPGroup.h"
#import "TTPSharedSettingsController.h"

/**
 Group selection view.
 */
@interface TTPGroupViewController : UITableViewController <MBProgressHUDDelegate>

/**
 Selected department from the previous screen.
 */
@property (nonatomic, strong) TTPDepartment *selectedDepartment;

@end
