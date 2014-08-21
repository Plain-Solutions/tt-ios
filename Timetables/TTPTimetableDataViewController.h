//
//  TTPTimetableDataViewController.h
//  Timetables
//
//  Created by Vladislav Slepukhin on 23/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TTPSubjectCell.h"
#import "ViewControllerDefines.h"

#import "TTPTimetableAccessor.h"
#import "TTPDaySequenceEntity.h"
#import "TTPSubjectEntity.h"
#import "TTPParser.h"
#import "TTPGroup.h"
#import "TTPSubgroup.h"
#import "TTPSharedSettingsController.h"

#define CELL_HEIGHT 60


@interface TTPTimetableDataViewController : UITableViewController

@property (assign, nonatomic) NSInteger day;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) TTPTimetableAccessor *accessor;
@property (assign, nonatomic) NSInteger parity;
@property (strong, nonatomic) NSArray *dayLessons;
@property (assign, nonatomic) BOOL isLoadedFromCache;

@end
