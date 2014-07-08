//
//  TTPSavedGroupsViewController.h
//  Timetables
//
//  Created by Vladislav Slepukhin on 07/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTPGroup.h"
#import "TTPParser.h"
#import "TTPTimetableViewController.h"
#import "TTPDepMsgViewController.h"

@interface TTPSavedGroupsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *favs;
@property (nonatomic, strong) TTPGroup *selectedGroup;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;
- (IBAction)addGroupToFavs:(id)sender;


@end
