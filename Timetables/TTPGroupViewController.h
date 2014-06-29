//
//  TTPGroupViewController.h
//  Timetables
//
//  Created by Vlad Selpukhin on 29/06/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTPDepartment.h"
@interface TTPGroupViewController : UITableViewController
@property (nonatomic, strong) NSMutableArray* groupList;
@property (nonatomic, strong) TTPDepartment* selectedDepartment;
@property (nonatomic, weak) IBOutlet UIBarButtonItem* nextButton;
@end
