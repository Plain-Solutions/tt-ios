//
//  TTPSavedGroupsViewController.m
//  Timetables
//
//  Created by Vladislav Slepukhin on 07/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import "TTPSavedGroupsViewController.h"
#import "MVYSideMenuController.h"
#define IOS7_DEFAULT_NAVBAR_ITEM_BLUE_COLOR [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];


@interface TTPSavedGroupsViewController () <UITableViewDelegate, UITableViewDataSource>
{
	TTPGroup *_confirmDeletedMyGroup;
}
@property (nonatomic, strong) NSMutableArray *savedGroups;
@property (nonatomic, strong) TTPParser *parser;
@property (nonatomic, strong) TTPGroup *myGroup;
@property (nonatomic, strong) NSUserDefaults *defaults;
@property (assign) NSInteger myGrpIndex;
@end

@implementation TTPSavedGroupsViewController

- (void)viewDidLoad;
{
	[super viewDidLoad];
	[[self navigationController] setNavigationBarHidden:NO animated:YES];
	self.navigationItem.title = NSLocalizedString(@"Saved groups", nil);
	self.depMsgButton.title = NSLocalizedString(@"Department message", nil);
	self.favs.delegate = self;
	self.favs.dataSource = self;
	[self.view addSubview:self.favs];

	self.defaults = [NSUserDefaults standardUserDefaults];
	NSData *data = [self.defaults objectForKey:@"savedGroups"];
	self.savedGroups = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];

	self.myGroup = [NSKeyedUnarchiver unarchiveObjectWithData:[self.defaults objectForKey:@"myGroup"]];

	self.parser = [[TTPParser alloc] init];
	
	for (TTPGroup *g in self.savedGroups) {
		if ([g.departmentName isEqualToString:self.myGroup.departmentName] &&
			[g.groupName isEqualToString:self.myGroup.groupName]) {
			self.myGrpIndex = [self.savedGroups indexOfObject:g];
		}
		if ([g.departmentName isEqualToString:self.selectedGroup.departmentName] &&
			[g.groupName isEqualToString:self.selectedGroup.groupName])
			self.addButton.enabled = NO;
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
    UITableViewCell *cell = [self.favs dequeueReusableCellWithIdentifier:@"savedGroup" forIndexPath:indexPath];
	TTPGroup *group = [self.savedGroups objectAtIndex:indexPath.row];
	cell.textLabel.textColor = IOS7_DEFAULT_NAVBAR_ITEM_BLUE_COLOR;
	
	BOOL isMyGroup = NO;
	if ([group.groupName isEqualToString:self.myGroup.groupName] &&
		[group.departmentName isEqualToString:self.myGroup.departmentName]) {
			[cell.textLabel setFont:[UIFont italicSystemFontOfSize:[UIFont systemFontSize]]];
			[cell.detailTextLabel setFont:[UIFont italicSystemFontOfSize:[UIFont systemFontSize]]];
			isMyGroup = YES;
			if ([self.selectedGroup.groupName isEqualToString:self.myGroup.groupName] &&
				[self.selectedGroup.departmentName isEqualToString:self.myGroup.departmentName]) {
					[cell.textLabel setFont:[UIFont fontWithName:@"Helvetica-BoldOblique" size:[UIFont systemFontSize]]];
					[cell.detailTextLabel setFont:[UIFont fontWithName:@"Helvetica-BoldOblique" size:[UIFont systemFontSize]]];
			}
	}
	else
		if ([group.groupName isEqualToString:self.selectedGroup.groupName] &&
			[group.departmentName isEqualToString:self.selectedGroup.departmentName]) {
				[cell.textLabel setFont:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]]];
				[cell.detailTextLabel setFont:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]]];
	}
		 
    cell.textLabel.text = (isMyGroup)? [NSString stringWithFormat:NSLocalizedString(@"%@ (mine)", nil), group.groupName]:group.groupName;
	cell.detailTextLabel.text = [self.parser prettifyDepartmentNames:group.departmentName];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
{
	return (indexPath.row == self.myGrpIndex)?NO:YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		[self.savedGroups removeObjectAtIndex:indexPath.row];
		NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.savedGroups];
		[self.defaults setObject:data forKey:@"savedGroups"];
		[self.defaults synchronize];
		[self.favs reloadData];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;
{
    if ([segue.identifier isEqualToString:@"viewTimetable"]) {
        [self.favs scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
		UITableViewCell *cell = (UITableViewCell*)sender;
        NSIndexPath *indexPath = [self.favs indexPathForCell:cell];
		
        TTPTimetableViewController *controller = [segue destinationViewController];
		controller.selectedGroup = [self.savedGroups objectAtIndex:indexPath.row];

    }
	if ([segue.identifier isEqualToString:@"viewMessage"]) {
		TTPDepMsgViewController *controller = [segue destinationViewController];
		controller.departmentTag = self.selectedGroup.departmentTag;
	}
}

- (IBAction)menuBtnPressed:(id)sender {
	MVYSideMenuController *sideMenuController = [self sideMenuController];
	if (sideMenuController) {
		[sideMenuController openMenu];
	}

}

- (IBAction)addGroupToFavs:(id)sender;
{
	// defaults
	NSData *data = [self.defaults objectForKey:@"savedGroups"];
	NSMutableArray *savedGroups = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
	TTPGroup *grp = [self.selectedGroup copy];
	[savedGroups addObject:grp];
	NSData *updatedData = [NSKeyedArchiver archivedDataWithRootObject:savedGroups];
	[self.defaults setObject:updatedData forKey:@"savedGroups"];
	[self.defaults synchronize];

	// UI
	[self.savedGroups addObject:grp];
	[self.favs reloadData];
	self.addButton.enabled = NO;
}
@end
