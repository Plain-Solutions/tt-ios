//
//  TTPMainViewContainerViewController.h
//  Timetables
//
//  Created by Vladislav Slepukhin on 23/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ViewControllerDefines.h"

@interface TTPMainViewContainerViewController : UIViewController <UIPageViewControllerDelegate, MBProgressHUDDelegate>

@property (strong, nonatomic) UIPageViewController *timetableViewController;

@end
