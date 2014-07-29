//
//  TTPMainViewController.h
//  Timetables
//
//  Created by Vladislav Slepukhin on 23/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTPGroup.h"

@interface TTPMainViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *paritySelector;

- (IBAction)dayButtonTapped:(id)sender;

- (IBAction)menuBtnTapped:(id)sender;
@end
