//
//  TTPTimetableDataViewController.h
//  Timetables
//
//  Created by Vladislav Slepukhin on 23/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTPDaySequenceEntity.h"
#import "TTPSubjectEntity.h"
#import "TTPSubgroup.h"
#import "TTPTimetableAccessor.h"

@interface TTPTimetableDataViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (assign, nonatomic) NSInteger day;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) TTPTimetableAccessor *accessor;
@property (assign, nonatomic) NSInteger parity;
@property (strong, nonatomic) NSArray *dayLessons;

@end
