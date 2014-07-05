//
//  TTPSubgroupCell.h
//  Timetables
//
//  Created by Vlad Selpukhin on 05/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTPSubgroupCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *subgroupNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subgroupLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *subgroupTeacherName;

@end
