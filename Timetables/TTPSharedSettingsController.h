//
//  TTPSharedSettingsController.h
//  Timetables
//
//  Created by Vladislav Slepukhin on 13/08/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 This class unifies all the settings in the app for more convinient access
 */
@interface TTPSharedSettingsController : NSObject
@property (nonatomic, assign) BOOL cameFromSettings;
@property (nonatomic, assign) BOOL wasCfgd;

+ (id)sharedSettings;
@end
