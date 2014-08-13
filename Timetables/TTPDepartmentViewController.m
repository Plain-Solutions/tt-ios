//
//  TTPDepartmentViewController.m
//  Timetables
//
//  Created by Vlad Selpukhin on 29/06/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import "TTPDepartmentViewController.h"
#import "MVYSideMenuController.h"

@interface TTPDepartmentViewController ()
@property (nonatomic, strong) TTPParser *parser;
@end

@implementation TTPDepartmentViewController {
	NSUserDefaults *_defaults;
}

- (id)initWithStyle:(UITableViewStyle)style;
{
    if (self = [super initWithStyle:style]) {
    }
    return self;
}

- (void)viewDidLoad;
{
   [super viewDidLoad];
	
	self.title= NSLocalizedString(@"Select department", nil);
	_defaults = [NSUserDefaults standardUserDefaults];

	

	if ([_defaults boolForKey:@"cameFromSettings"]) {
		[self.navigationItem setHidesBackButton:NO animated:YES];
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backBtnTapepd:)];
	}
	else if (![_defaults boolForKey:@"wasCfgd"])
		[self.navigationItem setHidesBackButton:YES animated:NO];
	else
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu-25"]
																			 style:UIBarButtonItemStyleBordered
																			target:self
																			action:@selector(menuBtnTapped:)];

	MBProgressHUD *loadingView = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:loadingView];
	loadingView.delegate = self;
	
	loadingView.labelText = NSLocalizedString(@"Loading departments list", nil);
	[loadingView show:YES];
	
	dispatch_queue_t downloadQueue = dispatch_queue_create("downloader", NULL);
    dispatch_async(downloadQueue, ^{
		NSString *depURL = @"http://api.ssutt.org:8080/1/departments";
		ShowNetworkActivityIndicator();

		NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: depURL]
												 cachePolicy:NSURLRequestUseProtocolCachePolicy
											 timeoutInterval:60];
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request
											 returningResponse:&response
														 error:&error];
		dispatch_async(dispatch_get_main_queue(), ^{
			self.parser = [[TTPParser alloc] init];

			if (response.statusCode != 200) {
				NSString *errorData = [[NSString alloc] init];
				if (data != nil)
					errorData = [self.parser parseError:data error:error];
				NSString *alertTitle = NSLocalizedString(@"Something bad happened!", nil);
				
				NSString *msg = [NSString stringWithFormat:NSLocalizedString(@"Please report the following error and restart the app:\n%@ on %@ with %d", nil),
								 errorData, depURL, response.statusCode];
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle: alertTitle																message: msg
															   delegate: nil
													  cancelButtonTitle:@"OK"
													  otherButtonTitles:nil];
				
				[alert show];
				
			}
			else {
				self.departmentList = [self.parser parseDepartments:data error:error];
			[self.tableView reloadData];
			}
			[loadingView hide:YES];
			HideNetworkActivityIndicator();
        });
    });

}

- (void)viewWillAppear:(BOOL)animated;
{
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning;
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
   return self.departmentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DepCell" forIndexPath:indexPath];

    if (cell == nil) {
		cell = [tableView dequeueReusableCellWithIdentifier:@"DepCell" forIndexPath:indexPath];
	}
	
    TTPDepartment *dep = [self.departmentList objectAtIndex:indexPath.row];
    
	cell.textLabel.text = [self.parser prettifyDepartmentNames:dep.name trim:YES];
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;
{
    if ([segue.identifier isEqualToString:@"groupSelect"]) {
		
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
		UITableViewCell *cell = (UITableViewCell*)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
		
        TTPGroupViewController *controller = [segue destinationViewController];
		TTPDepartment *dep = [self.departmentList objectAtIndex:indexPath.row];
		controller.selectedDepartment = dep;
    }
}



- (IBAction)menuBtnTapped:(id)sender {
	
	MVYSideMenuController *sideMenuController = [self sideMenuController];
	if (sideMenuController) {
		[sideMenuController openMenu];
	}
}

- (IBAction)backBtnTapepd:(id)sender {
	MVYSideMenuController *sideMenuController = [self sideMenuController];
	[_defaults setBool:NO forKey:@"cameFromSettings"];
	[_defaults setBool:YES forKey:@"wasCfgd"];
	[_defaults synchronize];
	UIViewController *contentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsView"];
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:contentVC];
	[sideMenuController changeContentViewController:navigationController closeMenu:YES];

}

@end
