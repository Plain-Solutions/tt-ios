//
//  TTPGroupViewController.m
//  Timetables
//
//  Created by Vlad Selpukhin on 29/06/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import "TTPGroupViewController.h"

@interface TTPGroupViewController ()
@property (nonatomic, strong) TTPParser *parser;
@end

@implementation TTPGroupViewController
@synthesize selectedDepartment = _selectedDepartment;
@synthesize groupList = _groupList;

- (id)initWithStyle:(UITableViewStyle)style;
{
    self = [super initWithStyle:style];
    return self;
}

- (void)viewDidLoad;
{
    [super viewDidLoad];
    self.title = self.selectedDepartment.name;

	
	
	dispatch_queue_t downloadQueue = dispatch_queue_create("downloader", NULL);
    dispatch_async(downloadQueue, ^{
		NSString *groupURL = [NSString stringWithFormat:@"http://api.ssutt.org:8080/1/department/%@/groups?filled=1",
							  self.selectedDepartment.tag];

		ShowNetworkActivityIndicator();
		NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString: groupURL]
												 cachePolicy:NSURLRequestUseProtocolCachePolicy
											 timeoutInterval:60];
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

        dispatch_async(dispatch_get_main_queue(), ^{
			self.parser = [[TTPParser alloc] init];
			
			if (response.statusCode != 200) {
				NSString *errorData = [[NSString alloc] init];
				if (data != nil)
					errorData = [self.parser parseError:data error:error];
				
				NSString *msg = [NSString stringWithFormat:@"Please report the following error and restart the app:\n%@ at %@(%@) with",
								 errorData, self.selectedDepartment.tag, groupURL, response.statusCode];
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Something bad happended!"
																message: msg
															   delegate: nil
													  cancelButtonTitle:@"OK"
													  otherButtonTitles:nil];
				[alert show];
			}
			else
				self.groupList = [self.parser parseGroups:data error:error];
			
			[self.tableView reloadData];
			HideNetworkActivityIndicator();
        });
    });

}

- (void)viewWillAppear:(BOOL)animated;
{
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO];
	NSLog(@"Here");
	[self.tableView reloadData];
}

- (void)didReceiveMemoryWarning;
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.groupList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GroupCell"];
    }
	
    cell.textLabel.text = [self.groupList objectAtIndex:indexPath.row];

    return cell;
}

#pragma mark - Navigation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
	NSString *groupName = [self.groupList objectAtIndex:indexPath.row];
	TTPGroup *selectedGroup = [[TTPGroup alloc] init];
	selectedGroup.departmentName = self.selectedDepartment.name;
	selectedGroup.departmentTag = self.selectedDepartment.tag;
	selectedGroup.groupName = groupName;

	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:
									[defaults objectForKey:@"usedStoryboard"]bundle:nil];
	
	if ([defaults boolForKey:@"firstRun"] == YES) {
		[defaults setBool:NO forKey:@"firstRun"];

		NSData *grp = [NSKeyedArchiver archivedDataWithRootObject:selectedGroup];
		NSData *favs = [NSKeyedArchiver archivedDataWithRootObject:[NSArray arrayWithObject:selectedGroup]];
		[defaults setObject:grp forKey:@"myGroup"];
		[defaults setObject:favs forKey:@"savedGroups"];
		[defaults synchronize];
	}
	
	TTPTimetableViewController *controller = [mainStoryboard instantiateViewControllerWithIdentifier:@"mainView"];
	
	controller.selectedGroup = selectedGroup;

	[self.navigationController pushViewController:controller animated:YES];
}

@end
