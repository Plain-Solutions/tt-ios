//
//  ViewControllerDefines.h
//  Timetables
//
//  Created by Vladislav Slepukhin on 03/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#ifndef Timetables_ViewControllerDefines_h
#define Timetables_ViewControllerDefines_h

#define ShowNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
#define HideNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = NO

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

#define OpenMenu() MVYSideMenuController *sideMenuController = [self sideMenuController]; if (sideMenuController) [sideMenuController openMenu]

#define BackButtonTap(viewString) MVYSideMenuController *sideMenuController = [self sideMenuController];	UIViewController *contentVC = [self.storyboard instantiateViewControllerWithIdentifier:viewString];	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:contentVC];	[sideMenuController changeContentViewController:navigationController closeMenu:YES]





#endif
