//
//  TTPSubjectCell.h
//  Timetables
//
//  Created by Vladislav Slepukhin on 02/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTPSubjectCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *beginTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *subjectNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subjectTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@end
