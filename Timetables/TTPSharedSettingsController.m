//
//  TTPSharedSettingsController.m
//  Timetables
//
//  Created by Vladislav Slepukhin on 13/08/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import "TTPSharedSettingsController.h"

@implementation TTPSharedSettingsController {
	NSUserDefaults *_defaults;
}

@synthesize cameFromSettings = _cameFromSettings;
@synthesize wasCfgd = _wasCfgd;
@synthesize myGroup = _myGroup;
@synthesize selectedGroup = _selectedGroup;

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
		_cameFromSettings = [_defaults boolForKey:@"cameFromSettings"];
		_wasCfgd = [_defaults boolForKey:@"wasCfgd"];
		_myGroup = [_defaults objectForKey:@"myGroup"];
		_selectedGroup = [_defaults objectForKey:@"selectedGroup"];
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
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:value];
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
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:value];
	[_defaults setObject:data forKey:@"selectedGroup"];
	[_defaults synchronize];
}

- (TTPGroup *)selectedGroup
{
	return _selectedGroup;
}

@end
