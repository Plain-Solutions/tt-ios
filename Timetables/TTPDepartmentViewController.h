//
//  TTPDepartmentViewController.h
//  Timetables
//
//  Created by Vlad Selpukhin on 29/06/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTPDepartment.h"
@interface TTPDepartmentViewController : UITableViewController
@property (nonatomic, assign) TTPDepartment* selectedDepartment;
@property (nonatomic, strong) NSMutableArray* departmentList;
@property (nonatomic, weak) IBOutlet UIBarButtonItem* nextButton;
@end
