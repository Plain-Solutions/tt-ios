//
//  TTPSharedSettingsController.h
//  Timetables
//
//  Created by Vladislav Slepukhin on 13/08/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TTPGroup.h"

#define ARCHIVE(data) [NSKeyedArchiver archivedDataWithRootObject:data]

#define UNARCHIVE(data)	[NSKeyedUnarchiver unarchiveObjectWithData:data]

#define MUTIFY_ARRAY(array) [NSMutableArray arrayWithArray:array]
/**
 This class unifies all the settings in the app for more convinient access
 */
@interface TTPSharedSettingsController : NSObject
@property (assign) BOOL cameFromSettings;
@property (assign) BOOL wasCfgd;
@property (assign) BOOL noSavedGroupsShownHelp;

@property (strong) TTPGroup *myGroup;
@property (strong) TTPGroup *selectedGroup;
@property (strong) NSArray *savedGroups;

+ (id)sharedController;
- (void)addSelectedGroupToFavorites;
@end
