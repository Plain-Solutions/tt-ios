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
#import "TTPDepartmentViewController.h"

@implementation TTPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
{	
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainDemo2" bundle:nil];

	TTPMenuViewController *menuVC = [storyboard instantiateViewControllerWithIdentifier:@"MenuView"];
	
	TTPMainViewController *contentVC = [storyboard instantiateViewControllerWithIdentifier:@"MainView"];
	UINavigationController *contentNavigationController = [[UINavigationController alloc] initWithRootViewController:contentVC];

	MVYSideMenuOptions *options = [[MVYSideMenuOptions alloc] init];
	options.contentViewScale = 1.0;
	options.contentViewOpacity = 0.05;
	options.shadowOpacity = 0.0;
	
	MVYSideMenuController *sideMenuController = [[MVYSideMenuController alloc] initWithMenuViewController:menuVC
																					contentViewController:contentNavigationController
																								  options:options];
	
	sideMenuController.menuFrame = CGRectMake(0, 65.0, 220.0, self.window.bounds.size.height); //- 98.5);
	
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
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:nil forKey:@"selectedGroup"];
}

@end
