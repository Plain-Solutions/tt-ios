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

#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)

#endif
