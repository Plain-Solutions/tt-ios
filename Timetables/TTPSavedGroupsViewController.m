//
//  TTPSavedGroupsViewController.m
//  Timetables
//
//  Created by Vladislav Slepukhin on 07/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import "TTPSavedGroupsViewController.h"
#import "MVYSideMenuController.h"
#import "TTPGroup.h"
#import "TTPParser.h"
#import "TTPMainViewController.h"
#import "TTPSavedGroupCell.h"

@interface TTPSavedGroupsViewController ()
{
	TTPGroup *_confirmDeletedMyGroup;
}
@property (nonatomic, strong) NSMutableArray *savedGroups;
@property (nonatomic, strong) TTPGroup *myGroup;
@property (nonatomic, strong) TTPParser *parser;
@property (nonatomic, strong) NSUserDefaults *defaults;
@end

@implementation TTPSavedGroupsViewController

@synthesize parser = _parser;

- (void)viewDidLoad;
{
	[super viewDidLoad];
	[[self navigationController] setNavigationBarHidden:NO animated:YES];
	self.navigationItem.title = NSLocalizedString(@"Saved groups", nil);

	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	
	self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
	self.navigationItem.leftBarButtonItem.title = NSLocalizedString(@"Back", nil);
	
	self.parser = [[TTPParser alloc] init];
	
	self.savedGroups = [[NSMutableArray alloc] init];
	
	self.defaults = [NSUserDefaults standardUserDefaults];
	NSData *data = [self.defaults objectForKey:@"savedGroups"];
	if (data != NULL)
		self.savedGroups =[NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
	
	[self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	if ([self.defaults boolForKey:@"noSavedGroupsShownHelp"] == NO && !self.savedGroups.count) {
		NSString *alertTitle = NSLocalizedString(@"Saved groups", nil);
		
		NSString *msg = NSLocalizedString(@"Here you can store your friends' groups for quick access. To add a group tap ★ on the main view right corner", nil);
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle: alertTitle
														message: msg
													   delegate: nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		
		[alert show];
		[self.defaults setBool:YES forKey: @"noSavedGroupsShownHelp"];
		[self.defaults synchronize];
	}

}

- (void)didReceiveMemoryWarning;
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.savedGroups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    TTPSavedGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"savedGroup" forIndexPath:indexPath];
	
	if (cell == nil)
		cell = [tableView dequeueReusableCellWithIdentifier:@"savedGroup" forIndexPath:indexPath];
	
	TTPGroup *group = [self.savedGroups objectAtIndex:indexPath.row];
	cell.departmentLabel.text = [self.parser prettifyDepartmentNames:group.departmentName trim:NO];
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
		[self.savedGroups removeObjectAtIndex:indexPath.row];
		NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.savedGroups];
		[self.defaults setObject:data forKey:@"savedGroups"];
		[self.defaults synchronize];
		[self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]]
							  withRowAnimation:UITableViewRowAnimationFade];
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:(TTPGroup *)self.savedGroups[indexPath.row]] forKey:@"selectedGroup"];
	[self.defaults synchronize];
	
	TTPMainViewController *contentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MainView"];
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:contentVC];
	if (![self.presentedViewController isBeingDismissed])
	{
		[[self sideMenuController] changeContentViewController:navigationController closeMenu:YES];
	}
	
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 18 + [self heightForText:((TTPGroup *)self.savedGroups[indexPath.row]).departmentName];
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


- (IBAction)menuBtnPressed:(id)sender {
	MVYSideMenuController *sideMenuController = [self sideMenuController];
	if (sideMenuController) {
		[sideMenuController openMenu];
	}

}

@end
