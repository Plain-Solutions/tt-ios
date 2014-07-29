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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	_menuItems = @[@"Set my Group", @"Reset saved groups", @"Reset all"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSArray *ids = @[@"setGroup", @"resetFavs", @"resetAll"];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ids[indexPath.section]];
	if (cell == nil) {
		cell = [tableView dequeueReusableCellWithIdentifier:ids[indexPath.section]];
	}
		
	cell.textLabel.text = NSLocalizedString(_menuItems[indexPath.section], nil);
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

	switch (indexPath.section) {
  case 0:
			[defaults setBool:NO forKey:@"wasCfgd"];
			[defaults setBool:YES forKey:@"cameFromSettings"];
			[defaults synchronize];
			UIViewController *contentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DepView"];
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:contentVC];
			[[self sideMenuController] changeContentViewController:navigationController closeMenu:YES];
			break;
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
