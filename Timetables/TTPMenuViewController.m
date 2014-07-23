//
//  TTPMenuViewController.m
//  Timetables
//
//  Created by Vladislav Slepukhin on 23/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import "TTPMenuViewController.h"
#import "MVYSideMenuController.h"

#import "TTPDepMsgViewController.h"

@interface TTPMenuViewController ()

@end

@implementation TTPMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

	// DepView is for search
	self.menuItems = @[@"MainView", @"DepMsgView", @"SavedGroupsView", @"DepView", @"SettingsView"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

#pragma mark - Navigation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == 0) {
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		[defaults setObject:nil forKey:@"selectedGroup"];
	}
	
	TTPDepMsgViewController *contentVC = [self.storyboard instantiateViewControllerWithIdentifier:self.menuItems[indexPath.row]];
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:contentVC];
	[[self sideMenuController] changeContentViewController:navigationController closeMenu:YES];
}

@end
