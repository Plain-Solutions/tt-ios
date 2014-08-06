//
//  TTPSubgroupCell.h
//  Timetables
//
//  Created by Vlad Selpukhin on 05/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Cell to display detailed subgroup information
 */
@interface TTPSubgroupCell : UITableViewCell

/**
 Name of the subgroup if any.
 */
@property (weak, nonatomic) IBOutlet UILabel *subgroupNameLabel;

/**
 The place: building + room
 */
@property (weak, nonatomic) IBOutlet UILabel *subgroupLocationLabel;

/**
 Teacher's name.
 */
@property (weak, nonatomic) IBOutlet UILabel *subgroupTeacherName;

@end
