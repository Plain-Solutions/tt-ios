//
//  TTPSavedGroupsViewController.m
//  Timetables
//
//  Created by Vladislav Slepukhin on 07/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import "TTPSavedGroupsViewController.h"

@interface TTPSavedGroupsViewController ()
@end

@implementation TTPSavedGroupsViewController {
	NSMutableArray *_savedGroups;
	TTPParser *_parser;
	TTPSharedSettingsController *_settings;
	TTPGroup *_confirmDeletedMyGroup;
}

- (void)viewDidLoad;
{
	[super viewDidLoad];
	_settings = [TTPSharedSettingsController sharedController];
	[[self navigationController] setNavigationBarHidden:NO animated:YES];
	self.navigationItem.title = NSLocalizedString(@"Saved groups", nil);

	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	
	self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
	
	_parser = [TTPParser sharedParser];
	
	_savedGroups = (_settings.savedGroups)?MUTIFY_ARRAY(_settings.savedGroups):nil;
	
	[self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	if ( !_settings.noSavedGroupsShownHelp && !_savedGroups.count) {
		NSString *alertTitle = NSLocalizedString(@"Saved groups", nil);
		
		NSString *msg = NSLocalizedString(@"Here you can store your friends' groups for quick access. To add a group tap ★ on the main view right corner", nil);
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle: alertTitle
														message: msg
													   delegate: nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		
		[alert show];
		_settings.noSavedGroupsShownHelp = YES;
	}

}

- (void)didReceiveMemoryWarning;
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return _savedGroups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    TTPSavedGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"savedGroup" forIndexPath:indexPath];
	
	if (cell == nil)
		cell = [tableView dequeueReusableCellWithIdentifier:@"savedGroup" forIndexPath:indexPath];
	
	TTPGroup *group = [_savedGroups objectAtIndex:indexPath.row];
	cell.departmentLabel.text = [_parser prettifyDepartmentNames:group.departmentName trim:NO];
	cell.groupLabel.text=  group.groupName;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
{
	return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		[_savedGroups removeObjectAtIndex:indexPath.row];
		_settings.savedGroups = _savedGroups;

		[self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]]
							  withRowAnimation:UITableViewRowAnimationFade];
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	_settings.selectedGroup = _savedGroups[indexPath.row];
	
	TTPMainViewController *contentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MainView"];
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:contentVC];
	if (![self.presentedViewController isBeingDismissed])
	{
		[[self sideMenuController] changeContentViewController:navigationController closeMenu:YES];
	}
	
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 18 + [self heightForText:((TTPGroup *)_savedGroups[indexPath.row]).departmentName];
}

-(CGFloat)heightForText:(NSString *)text
{
	NSInteger MAX_HEIGHT = 2000;
	UITextView * textView = [[UITextView alloc] initWithFrame: CGRectMake(0, 0, 280, MAX_HEIGHT)];
	textView.text = text;
	textView.font = [UIFont fontWithName:@"Helvetica-Neue-Light" size:15.0f];
	[textView sizeToFit];
	return textView.frame.size.height;
}

#pragma mark - Actions

- (IBAction)menuBtnPressed:(id)sender {
	OpenMenu();
}

@end
