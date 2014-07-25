//
//  TTPGroupViewController.h
//  Timetables
//
//  Created by Vlad Selpukhin on 29/06/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewControllerDefines.h"
#import "TTPDepartment.h"
#import "TTPParser.h"
#import "TTPGroup.h"
/**
 Group selection view.
 */
@interface TTPGroupViewController : UITableViewController

/**
 Fetched grouplist.
 */
@property (nonatomic, strong) NSMutableArray *groupList;

/**
 Selected department from the last screen.
 */
@property (nonatomic, strong) TTPDepartment *selectedDepartment;

@end
