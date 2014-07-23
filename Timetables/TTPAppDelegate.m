//
//  TTPAppDelegate.m
//  Timetables
//
//  Created by Vlad Selpukhin on 29/06/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import "TTPAppDelegate.h"
#import "TTPMainViewController.h"
#import "TTPMenuViewController.h"
#import "MVYSideMenuController.h"

#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)

@implementation TTPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
{
	UIStoryboard *mainStoryboard = nil;
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

//	if ([defaults objectForKey:@"usedStoryboard"] == nil) {
//		NSLog(@"Display size not set.");
//		NSString *storyBoardName = (IS_IPHONE5)?@"Main-4":@"Main-35";
//		[defaults setObject:storyBoardName forKey:@"usedStoryboard"];
//		[defaults synchronize];
//	}
//	
//	if ([defaults objectForKey:@"myGroup"] == nil) {
//		[defaults setBool:YES forKey:@"firstRun"];
//		[defaults synchronize];
//		mainStoryboard = [UIStoryboard storyboardWithName:@"SearchViews" bundle:nil];
//		self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//		self.window.rootViewController = [mainStoryboard instantiateInitialViewController];
//		[self.window makeKeyAndVisible];
//	}
//	else {
//	mainStoryboard = [UIStoryboard storyboardWithName:[defaults objectForKey:@"usedStoryboard"]bundle:nil];
//
	mainStoryboard = [UIStoryboard storyboardWithName:@"MainDemo2" bundle:nil];
//	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
//	[self.window makeKeyAndVisible];
//	}
	
	TTPMenuViewController *menuVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"MenuView"];
	
	TTPMainViewController *contentVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"MainView"];
	UINavigationController *contentNavigationController = [[UINavigationController alloc] initWithRootViewController:contentVC];

	MVYSideMenuOptions *options = [[MVYSideMenuOptions alloc] init];
	options.contentViewScale = 1.0;
	options.contentViewOpacity = 0.05;
	options.shadowOpacity = 0.0;
	
	MVYSideMenuController *sideMenuController = [[MVYSideMenuController alloc] initWithMenuViewController:menuVC
																					contentViewController:contentNavigationController
																								  options:options];
	
	sideMenuController.menuFrame = CGRectMake(0, 65.0, 220.0, self.window.bounds.size.height - 103.0);

	self.window.rootViewController = sideMenuController;
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
