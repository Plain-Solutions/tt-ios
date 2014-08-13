//
//  TTPSavedGroupsViewController.h
//  Timetables
//
//  Created by Vladislav Slepukhin on 07/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MVYSideMenuController.h"
#import "TTPMainViewController.h"
#import "TTPSavedGroupCell.h"

#import "TTPGroup.h"
#import "TTPParser.h"
#import "TTPSharedSettingsController.h"

/**
 Saved in NSUserDefaults groups viewing.
 */
@interface TTPSavedGroupsViewController : UITableViewController

- (IBAction)menuBtnPressed:(id)sender;

@end
