//
//  TTPTimetableViewController.h
//  Timetables
//
//  Created by Vladislav Slepukhin on 30/06/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTPDepartment.h"
@interface TTPTimetableViewController : UIViewController
@property (nonatomic, strong) TTPDepartment* selectedDepartment;
@property (nonatomic, strong) NSString* selectedGroup;
@property (nonatomic, strong) NSMutableArray* timetableData;

@property (weak, nonatomic) IBOutlet UILabel *daynameLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *paritySelector;
@property (weak, nonatomic) IBOutlet UITableView *timetable;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchGroupsButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *savedGroupsButton;
@end
