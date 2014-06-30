//
//  TTPMainViewController.h
//  Timetables
//
//  Created by Vladislav Slepukhin on 30/06/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTPDepartment.h"

@interface TTPMainViewController : UITableViewController
@property (nonatomic, strong) TTPDepartment* selectedDepartment;
@property (nonatomic, strong) NSString* selectedGroup;
@property (nonatomic, strong) NSMutableArray* timetable;
@end
