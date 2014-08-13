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

+ (id)sharedSettings
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
		self.cameFromSettings = [_defaults boolForKey:@"cameFromSettings"];
		self.wasCfgd = [_defaults boolForKey:@"wasCfgd"];
		
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



@end
