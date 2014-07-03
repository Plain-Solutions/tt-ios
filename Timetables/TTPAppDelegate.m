//
//  TTPAppDelegate.m
//  Timetables
//
//  Created by Vlad Selpukhin on 29/06/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import "TTPAppDelegate.h"
#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)


@implementation TTPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
{
	UIStoryboard *mainStoryboard = nil;
	if (IS_IPHONE5) {
		mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	} else {
		mainStoryboard = [UIStoryboard storyboardWithName:@"Main-35" bundle:nil];
	}
	
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.rootViewController = [mainStoryboard instantiateInitialViewController];
	[self.window makeKeyAndVisible];
	
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
