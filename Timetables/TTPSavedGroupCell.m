//
//  TTPSavedGroupCell.m
//  Timetables
//
//  Created by Vladislav Slepukhin on 27/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import "TTPSavedGroupCell.h"

#define IOS7_DEFAULT_NAVBAR_ITEM_BLUE_COLOR [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];

@implementation TTPSavedGroupCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		self.groupLabel.textColor = IOS7_DEFAULT_NAVBAR_ITEM_BLUE_COLOR;
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
