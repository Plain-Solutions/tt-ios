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

@interface TTPSavedGroupsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *favs;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBarTitle;


@end
