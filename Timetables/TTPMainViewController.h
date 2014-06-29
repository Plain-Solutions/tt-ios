//
//  TTPMainViewController.h
//  Timetables
//
//  Created by Vladislav Slepukhin.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//
#import "TTPDepartment.h"

@interface TTPMainViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *subjectLabelName;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong) TTPDepartment* selectedDepartment;
@property (nonatomic, strong) NSString* selectedGroup;

- (IBAction)changeParity:(id)sender;
- (IBAction)changeDay:(id)sender;

@end
