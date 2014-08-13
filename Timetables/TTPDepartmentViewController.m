//
//  TTPDepartmentViewController.m
//  Timetables
//
//  Created by Vlad Selpukhin on 29/06/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import "TTPDepartmentViewController.h"


@interface TTPDepartmentViewController ()
@end

@implementation TTPDepartmentViewController {
	NSMutableArray *_departmentList;
	
	TTPSharedSettingsController *_settings;
	TTPParser *_parser;
}

- (void)viewDidLoad;
{
   [super viewDidLoad];
	_settings = [TTPSharedSettingsController sharedSettings];

	self.title= NSLocalizedString(@"Select department", nil);
	
	if (_settings.cameFromSettings) {
		[self.navigationItem setHidesBackButton:NO animated:YES];
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
												 initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
												 target:self
												 action:@selector(backBtnTapepd:)];
	}
	else if (!_settings.wasCfgd)
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
	
	// Downloading department list
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
			_parser = [[TTPParser alloc] init];

			if (response.statusCode != 200) {
				[self showErrorAlert:data
							   error:error
					   departmentURL:depURL
							response:response];
			}
			else {
				_departmentList = [_parser parseDepartments:data
													  error:error];
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
   return _departmentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DepCell" forIndexPath:indexPath];

    if (cell == nil) {
		cell = [tableView dequeueReusableCellWithIdentifier:@"DepCell" forIndexPath:indexPath];
	}
	
    TTPDepartment *dep = [_departmentList objectAtIndex:indexPath.row];
    
	cell.textLabel.text = [_parser prettifyDepartmentNames:dep.name trim:YES];
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
		TTPDepartment *dep = [_departmentList objectAtIndex:indexPath.row];
		controller.selectedDepartment = dep;
    }
}

- (IBAction)menuBtnTapped:(id)sender {
	OpenMenu();
}

- (IBAction)backBtnTapepd:(id)sender {
	_settings.cameFromSettings = NO;
	_settings.wasCfgd = YES;

	BackButtonTap(@"SettingsView");
}

#pragma mark - Alerts

- (void)showErrorAlert:(NSData *)data error:(NSError *)error departmentURL:(NSString *)depURL response:(NSHTTPURLResponse *)response
{
	NSString *errorData = [[NSString alloc] init];
	if (data != nil)
		errorData = [_parser parseError:data error:error];
	NSString *alertTitle = NSLocalizedString(@"Something bad happened!", nil);
	NSString *msg;
	if (response.statusCode)
		msg = [NSString stringWithFormat:NSLocalizedString(@"Please report the following error and restart the app:\n%@ on %@ with %d: %@", nil),
			   errorData, depURL, response.statusCode, errorData];
	else
		msg = NSLocalizedString(@"Network seems to be down. Please, turn on cellular connection or Wi-Fi", nil);
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle: alertTitle
													message: msg
												   delegate: nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	
	[alert show];

}

@end
