//
//  TTPSubjectCell.m
//  Timetables
//
//  Created by Vladislav Slepukhin on 02/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import "TTPSubjectCell.h"

@implementation TTPSubjectCell

@synthesize subjectNameLabel =_subjectNameLabel;
@synthesize subjectTypeLabel = _subjectTypeLabel;
@synthesize locationLabel = _locationLabel;
@synthesize activityView = _activityView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    return self;
}

- (void)awakeFromNib;
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
{
    [super setSelected:selected animated:animated];
}

@end
