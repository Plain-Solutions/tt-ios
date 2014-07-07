//
//  TTPAppDelegate.m
//  Timetables
//
//  Created by Vlad Selpukhin on 29/06/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import "TTPAppDelegate.h"


@implementation TTPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
{
	UIStoryboard *mainStoryboard = nil;
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

	if ([defaults objectForKey:@"usedStoryboard"] == nil) {
		NSLog(@"Display size not set.");
		NSString *storyBoardName = (IS_IPHONE5)?@"Main-4":@"Main-35";
		[defaults setObject:storyBoardName forKey:@"usedStoryboard"];
		[defaults synchronize];
	}
	
	if ([defaults objectForKey:@"myDepartmentName"] == nil || [defaults objectForKey:@"myDepartmentTag"] == nil || [defaults objectForKey:@"myGroup"] == nil) {
		[defaults setBool:YES forKey:@"firstRun"];
		[defaults synchronize];
		mainStoryboard = [UIStoryboard storyboardWithName:@"SearchViews" bundle:nil];
		self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
		self.window.rootViewController = [mainStoryboard instantiateInitialViewController];
		[self.window makeKeyAndVisible];
	}
	else {
	mainStoryboard = [UIStoryboard storyboardWithName:[defaults objectForKey:@"usedStoryboard"]bundle:nil];
		
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.rootViewController = [mainStoryboard instantiateInitialViewController];
	[self.window makeKeyAndVisible];
	}
	
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application;
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application;
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application;
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application;
{
}

- (void)applicationWillTerminate:(UIApplication *)application;
{
}

@end
