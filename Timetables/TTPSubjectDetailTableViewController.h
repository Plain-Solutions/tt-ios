//
//  TTPSubjectDetailTableViewController.h
//  Timetables
//
//  Created by Vlad Selpukhin on 04/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTPSubgroupCell.h"
#import "TTPSubjectEntity.h"
#import "TTPTimetableAccessor.h"

/**
 ViewController for the detailed view of each subject with 
 subgroups, teachers and locations.
 */
@interface TTPSubjectDetailTableViewController : UITableViewController

/**
 A subject to get information from.
 */
@property (nonatomic, weak) TTPSubjectEntity *subject;

/**
 Sequence of define subject as for API v2 sequence is not
 included in subject info. 
 */
@property (nonatomic, assign) NSInteger sequence;
@end
