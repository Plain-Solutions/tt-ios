//
//  TTPGroupViewController.m
//  Timetables
//
//  Created by Vlad Selpukhin on 29/06/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import "TTPGroupViewController.h"

@interface TTPGroupViewController ()
@end

@implementation TTPGroupViewController {
	NSMutableArray *_groupList;
	
	TTPParser *_parser;
	TTPSharedSettingsController *_settings;
}
@synthesize selectedDepartment = _selectedDepartment;

- (void)viewDidLoad;
{
    [super viewDidLoad];
	_settings = [TTPSharedSettingsController sharedController];
	
    self.title = self.selectedDepartment.name;
	
	MBProgressHUD *loadingView = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:loadingView];
	loadingView.delegate = self;
	loadingView.labelText = NSLocalizedString(@"Loading groups list", nil);
	[loadingView show:YES];
	
	
	// Downloading group list
	dispatch_queue_t downloadQueue = dispatch_queue_create("downloader", NULL);
    dispatch_async(downloadQueue, ^{
		NSString *groupURL = [NSString stringWithFormat:@"http://api.ssutt.org:8080/1/department/%@/groups?filled=0",
							  self.selectedDepartment.tag];
		ShowNetworkActivityIndicator();
		
		NSURLRequest *request = CreateRequest(groupURL);
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

        dispatch_async(dispatch_get_main_queue(), ^{
			_parser = [[TTPParser alloc] init];
			
			if (response.statusCode != 200) {
				[self showErrorAlert:data
							   error:error
							groupURL:groupURL
							response:response];
			}
			else {
				_groupList = [_parser parseGroups:data error:error];
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
    return _groupList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupCell" forIndexPath:indexPath];
    
	if (cell == nil) {
		cell = [tableView dequeueReusableCellWithIdentifier:@"GroupCell" forIndexPath:indexPath];
	}
	
    cell.textLabel.text = [_groupList objectAtIndex:indexPath.row];

    return cell;
}

#pragma mark - Navigation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
	NSString *groupName = [_groupList objectAtIndex:indexPath.row];
	
	TTPGroup *selectedGroup = [[TTPGroup alloc] init];
	selectedGroup.departmentName = self.selectedDepartment.name;
	selectedGroup.departmentTag = self.selectedDepartment.tag;
	selectedGroup.groupName = groupName;

	_settings.selectedGroup = selectedGroup;
	
	if (!_settings.wasCfgd) {
		_settings.wasCfgd = YES;
		_settings.myGroup = _settings.selectedGroup;
	}

	OpenMainView();
}

#pragma mark - Alerts
- (void)showErrorAlert:(NSData *)data error:(NSError *)error groupURL:(NSString *)groupURL response:(NSHTTPURLResponse *)response
{
	NSString *errorData = [[NSString alloc] init];
	if (data != nil)
		errorData = [_parser parseError:data error:error];
	NSString *title = NSLocalizedString(@"Something bad happened!", nil);
	
	NSString *msg;
	if (response.statusCode)
		msg = [NSString stringWithFormat:NSLocalizedString(@"Please report the following error and restart the app:\n%@ at %@(%@) with %d: %@", nil),
					 errorData, self.selectedDepartment.tag, groupURL, response.statusCode, errorData];
	else
		msg = NSLocalizedString(@"Network seems to be down. Please, turn on cellular connection or Wi-Fi", nil);

	UIAlertView *alert = [[UIAlertView alloc] initWithTitle: title
													message: msg
												   delegate: nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
}

@end
