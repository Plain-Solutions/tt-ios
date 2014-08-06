//
//  TTPSettingsViewController.m
//  Timetables
//
//  Created by Vladislav Slepukhin on 23/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import "TTPSettingsViewController.h"
#import "MVYSideMenuController.h"

@interface TTPSettingsViewController ()
@end

@implementation TTPSettingsViewController {
	NSArray *_menuItems;
	NSUserDefaults *_defaults;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = NSLocalizedString(@"Settings", nil);
	_menuItems = @[@"Set my Group", @"Reset saved groups"];
	_defaults = [NSUserDefaults standardUserDefaults];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _menuItems.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSArray *ids = @[@"setGroup", @"resetFavs"];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ids[indexPath.section]];
	if (cell == nil) {
		cell = [tableView dequeueReusableCellWithIdentifier:ids[indexPath.section]];
	}
		
	cell.textLabel.text = NSLocalizedString(_menuItems[indexPath.section], nil);
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {


	if (!indexPath.section) {
			[_defaults setBool:NO forKey:@"wasCfgd"];
			[_defaults setBool:YES forKey:@"cameFromSettings"];
			[_defaults synchronize];
			UIViewController *contentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DepView"];
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:contentVC];
			[[self sideMenuController] changeContentViewController:navigationController closeMenu:YES];

		}
	else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Reset?", nil)
														message:NSLocalizedString(@"Really reset saved groups list? This cannot be undone.", nil)
													   delegate:self
											  cancelButtonTitle:NSLocalizedString(@"No", nil)
											  otherButtonTitles: nil];
		[alert addButtonWithTitle:NSLocalizedString(@"Yes", nil)];
		[alert show];
	}
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	MBProgressHUD *loadingView = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:loadingView];
	loadingView.delegate = self;
	loadingView.labelText = NSLocalizedString(@"Resetting", nil);
		if (buttonIndex == 1) {
				[loadingView showAnimated:YES whileExecutingBlock:^
				{
					[_defaults setObject:nil forKey:@"savedGroups"];
					[_defaults synchronize];
				}completionBlock:nil];
			}
}

#pragma mark - Navigation

- (IBAction)menuBtnPressed:(id)sender {
	MVYSideMenuController *sideMenuController = [self sideMenuController];
	if (sideMenuController) {
		[sideMenuController openMenu];
	}
}

@end
