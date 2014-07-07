//
//  TTPSavedGroupsViewController.m
//  Timetables
//
//  Created by Vladislav Slepukhin on 07/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import "TTPSavedGroupsViewController.h"

#define IOS7_DEFAULT_NAVBAR_ITEM_BLUE_COLOR [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];


@interface TTPSavedGroupsViewController ()
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

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[[self navigationController] setNavigationBarHidden:NO animated:YES];
	self.title = @"Saved groups";
	
	self.defaults = [NSUserDefaults standardUserDefaults];
	NSData *data = [self.defaults objectForKey:@"savedGroups"];
	self.savedGroups = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];

	self.myGroup = [NSKeyedUnarchiver unarchiveObjectWithData:[self.defaults objectForKey:@"myGroup"]];

	self.parser = [[TTPParser alloc] init];
	
	for (TTPGroup *g in self.savedGroups) {
		if (g.departmentName == self.myGroup.departmentName && g.groupName == self.myGroup.groupName) {
			self.myGrpIndex = [self.savedGroups indexOfObject:g];
			break;
		}
		
	}
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
    return self.savedGroups.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"savedGroup" forIndexPath:indexPath];
	TTPGroup *group = [self.savedGroups objectAtIndex:indexPath.row];
	cell.textLabel.textColor = IOS7_DEFAULT_NAVBAR_ITEM_BLUE_COLOR;
	
	if ([group.groupName isEqualToString:self.myGroup.groupName] && [group.departmentName isEqualToString:self.myGroup.departmentName]) {
		[cell.textLabel setFont:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]]];
		[cell.detailTextLabel setFont:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]]];
	}
		 
    cell.textLabel.text = group.groupName;
	cell.detailTextLabel.text = [self.parser prettifyDepartmentNames:group.departmentName];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
	return (indexPath.row == self.myGrpIndex)?NO:YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		[self.savedGroups removeObjectAtIndex:indexPath.row];
		NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.savedGroups];
		[self.defaults setObject:data forKey:@"savedGroups"];
		[self.defaults synchronize];
		[self.tableView reloadData];
    }
}

//- (void)didMoveToParentViewController:(UIViewController *)parent
//{
//    if (![parent isEqual:self.parentViewController]) {
//		NSLog(@"%@", self.myGroup);
//		((TTPTimetableViewController*)self.parentViewController).addGroup.enabled = !(self.myGroup == nil);
//
//    }
//}
/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;
{
    if ([segue.identifier isEqualToString:@"viewTimetable"]) {
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
		UITableViewCell *cell = (UITableViewCell*)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

        TTPTimetableViewController *controller = [segue destinationViewController];
		controller.selectedGroup = [self.savedGroups objectAtIndex:indexPath.row];

    }
}



@end
