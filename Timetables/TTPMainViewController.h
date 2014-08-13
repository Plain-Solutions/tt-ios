//
//  TTPMainViewController.h
//  Timetables
//
//  Created by Vladislav Slepukhin on 23/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MVYSideMenuController.h"
#import "TTPDepartmentViewController.h"
#import "ViewControllerDefines.h"

#import "TTPGroup.h"
#import "TTPSharedSettingsController.h"

@interface TTPMainViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *paritySelector;

// This is for the next version
// - (IBAction)dayButtonTapped:(id)sender;

- (IBAction)menuBtnTapped:(id)sender;

@end
