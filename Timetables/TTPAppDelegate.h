//
//  TTPAppDelegate.h
//  Timetables
//
//  Created by Vlad Selpukhin on 29/06/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TTPMainViewController.h"
#import "TTPMenuViewController.h"
#import "MVYSideMenuController.h"
#import "TTPDepartmentViewController.h"
#import "ViewControllerDefines.h"

#import "TTPSharedSettingsController.h"

/** Default delegate file
 */
@interface TTPAppDelegate : UIResponder <UIApplicationDelegate>

/** App window
 */
@property (strong, nonatomic) UIWindow *window;

@end
