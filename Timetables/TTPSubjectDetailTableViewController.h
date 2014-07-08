//
//  TTPSubjectDetailTableViewController.h
//  Timetables
//
//  Created by Vlad Selpukhin on 04/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTPSubjectEntity.h"
#import "TTPTimetableAccessor.h"
#import "TTPSubgroupCell.h"

@interface TTPSubjectDetailTableViewController : UITableViewController
@property (nonatomic, weak) TTPSubjectEntity *subject;
@property (nonatomic, assign) NSInteger sequence;
@end
