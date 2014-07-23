//
//  TTPTimetableDataViewController.h
//  Timetables
//
//  Created by Vladislav Slepukhin on 23/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTPTimetableDataViewController : UIViewController
@property (strong, nonatomic) id dataObject;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end
