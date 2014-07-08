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
 Display beginning time.
 */
@property (weak, nonatomic) IBOutlet UILabel *beginTimeLabel;

/**
 Display finishing time.
 */
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

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
@property (weak, nonatomic) IBOutlet UILabel *dashLabel;

@end
