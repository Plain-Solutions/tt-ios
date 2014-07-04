//
//  TTPSubjectDetailTableViewController.h
//  Timetables
//
//  Created by Vlad Selpukhin on 04/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTPLesson.h"

@interface TTPSubjectDetailTableViewController : UITableViewController
@property (nonatomic, weak) TTPLesson *selectedLesson;
@end
