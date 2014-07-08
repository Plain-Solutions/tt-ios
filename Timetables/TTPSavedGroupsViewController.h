//
//  TTPSavedGroupsViewController.h
//  Timetables
//
//  Created by Vladislav Slepukhin on 07/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTPTimetableViewController.h"
#import "TTPDepMsgViewController.h"
#import "TTPGroup.h"
#import "TTPParser.h"

/**
 Saved in NSUserDefaults groups viewing.
 */
@interface TTPSavedGroupsViewController : UIViewController

/**
 Subview for displaying the list.
 */
@property (weak, nonatomic) IBOutlet UITableView *favs;

/**
 Passed group to be able to save it to the list.
 */
@property (nonatomic, strong) TTPGroup *selectedGroup;

/**
 Outlet to control the state of button (enabled/disabled).
 */
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;

- (IBAction)addGroupToFavs:(id)sender;
@end
