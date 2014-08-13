//
//  TTPSharedSettingsController.m
//  Timetables
//
//  Created by Vladislav Slepukhin on 13/08/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import "TTPSharedSettingsController.h"

#define ARCHIVE(data) [NSKeyedArchiver archivedDataWithRootObject:data];

#define UNARCHIVE(data)	[NSKeyedUnarchiver unarchiveObjectWithData:data]

@implementation TTPSharedSettingsController {
	NSUserDefaults *_defaults;
}

@synthesize cameFromSettings = _cameFromSettings;
@synthesize wasCfgd = _wasCfgd;
@synthesize myGroup = _myGroup;
@synthesize selectedGroup = _selectedGroup;
@synthesize savedGroups = _savedGroups;

+ (id)sharedController
{
	static TTPSharedSettingsController *sharedSettingsController = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedSettingsController = [[self alloc] init];
	});
	
	return sharedSettingsController;
}
- (id)init
{
	if (self = [super init]) {
		_defaults = [NSUserDefaults standardUserDefaults];

		_cameFromSettings = [_defaults  boolForKey:@"cameFromSettings"];
		_wasCfgd = [_defaults boolForKey:@"wasCfgd"];

		_myGroup = UNARCHIVE([_defaults objectForKey:@"myGroup"]);
		_selectedGroup = UNARCHIVE([_defaults objectForKey:@"selectedGroup"]);
		_savedGroups = UNARCHIVE([_defaults objectForKey:@"savedGroups"]);
	}
	return self;
}

- (void)setCameFromSettings:(BOOL)value
{
	_cameFromSettings = value;
	[_defaults setBool:_cameFromSettings forKey:@"cameFromSettings"];
	[_defaults synchronize];
}

- (void)setWasCfgd:(BOOL)value
{
	_wasCfgd = value;
	[_defaults setBool:_wasCfgd forKey:@"wasCfgd"];
	[_defaults synchronize];
}

- (BOOL)cameFromSettings
{
	return _cameFromSettings;
}

- (BOOL)wasCfgd
{
	return _wasCfgd;
}

- (void)setMyGroup:(TTPGroup *)value
{
	_myGroup = value;
	NSData *data = ARCHIVE(value);
	[_defaults setObject:data forKey:@"myGroup"];
	[_defaults synchronize];
}

- (TTPGroup *)myGroup
{
	return _myGroup;
}

- (void)setSelectedGroup:(TTPGroup *)value
{
	_selectedGroup = value;
	NSData *data = ARCHIVE(value);
	[_defaults setObject:data forKey:@"selectedGroup"];
	[_defaults synchronize];
}

- (TTPGroup *)selectedGroup
{
	return _selectedGroup;
}

- (void)setSavedGroups:(NSArray *)groups;
{
	NSData *data = ARCHIVE(groups);
	[_defaults setObject:data forKey:@"savedGroups"];
	[_defaults synchronize];
}

- (NSArray *)savedGroups
{
	return  _savedGroups;
}

- (void)addSelectedGroupToFavorites
{

	NSMutableArray *__savedGroups = [NSMutableArray arrayWithArray:_savedGroups];
	[__savedGroups addObject:_selectedGroup];
	_savedGroups = [NSArray arrayWithArray:__savedGroups];
	
	
	NSData *data = ARCHIVE(__savedGroups);
	[_defaults setObject:data forKey:@"savedGroups"];
	[_defaults synchronize];
}

@end
