//
//  TTPMenuViewController.m
//  Timetables
//
//  Created by Vladislav Slepukhin on 23/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import "TTPMenuViewController.h"


@interface TTPMenuViewController ()
@end

@implementation TTPMenuViewController {
	NSArray *_menuItems;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.tableFooterView = Frame(0,0,self.view.bounds.size.width,self.view.bounds.size.height);
	self.tableView.tableFooterView.backgroundColor = MenuViewColor;

	// DepView is for search
	_menuItems = @[@"MainView", @"DepMsgView", @"SavedGroupsView", @"DepView", @"SettingsView"];
	NSArray *menuNames = @[NSLocalizedString(@"My Group", nil),
						   NSLocalizedString(@"Dean Info", nil),
						   NSLocalizedString(@"Saved Groups", nil),
						   NSLocalizedString(@"Search", nil),
						   NSLocalizedString(@"Settings", nil)];
	for (int i = 0; i < 5; i++) {
		NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
		UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
		cell.textLabel.text = menuNames[i];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	UIView *view = ZeroFrame();
	self.tableView.tableFooterView.backgroundColor = MenuViewBackgroundColor;
	return view;
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
		TTPSharedSettingsController *settings = [TTPSharedSettingsController sharedController];
		settings.selectedGroup = settings.myGroup;
	}
	
	MenuItemTap(_menuItems[indexPath.row]);
}

@end
