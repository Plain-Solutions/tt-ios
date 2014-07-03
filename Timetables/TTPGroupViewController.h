//
//  TTPGroupViewController.h
//  Timetables
//
//  Created by Vlad Selpukhin on 29/06/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTPDepartment.h"

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

/**
 utton to proceed to group viewing.
 */
@property (nonatomic, weak) IBOutlet UIBarButtonItem *nextButton;
@end
