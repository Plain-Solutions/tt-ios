//
//  TTPSubjectCell.h
//  Timetables
//
//  Created by Vladislav Slepukhin on 02/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Main View custom cell.
 */
@interface TTPSubjectCell : UITableViewCell
/**
 Display beginning&finishing time.
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

/**
 Display subject name.
 */
@property (weak, nonatomic) IBOutlet UILabel *subjectNameLabel;

/**
 Display acitivty.
 */
@property (weak, nonatomic) IBOutlet UILabel *subjectTypeLabel;

/**
 Display place.
 */
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (weak, nonatomic) IBOutlet UIImageView *activityImg;


@end
