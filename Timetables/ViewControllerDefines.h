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
#define TableViewColor RGB(239, 239, 244)
#define MenuViewColor RGB(153, 153, 153)
#define MenuViewBackgroundColor RGB(102, 204, 255)

#define LectureColor RGB(255, 94, 58)
#define PracticeColor RGB(76, 217, 100)
#define LabColor RGB(90, 200, 250)

#define Frame(x, y, w, h) [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)]
#define ZeroFrame() [[UIView alloc] initWithFrame:CGRectZero];
#define ViewWidth self.view.bounds.size.width

#define OpenMenu() MVYSideMenuController *sideMenuController = [self sideMenuController]; if (sideMenuController) [sideMenuController openMenu]

#define MenuItemTap(viewString) MVYSideMenuController *sideMenuController = [self sideMenuController];	UIViewController *contentVC = [self.storyboard instantiateViewControllerWithIdentifier:viewString];	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:contentVC];	[sideMenuController changeContentViewController:navigationController closeMenu:YES]

#define OpenMainView() 	TTPMainViewController *contentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MainView"]; UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:contentVC];if (![self.presentedViewController isBeingDismissed]) {	[[self sideMenuController] changeContentViewController:navigationController closeMenu:YES];}

#define SetMenuButton() 	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu-25"] style:UIBarButtonItemStyleBordered target:self action:@selector(menuBtnTapped:)];

#define CreateRequest(url) [NSURLRequest requestWithURL: [NSURL URLWithString: url]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];

#endif
