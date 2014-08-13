//
//  TTPDepMsgViewController.m
//  Timetables
//
//  Created by Vladislav Slepukhin on 08/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import "TTPDepMsgViewController.h"
#import "MVYSideMenuController.h"
#import "TTPGroup.h"
#import "TTPSharedSettingsController.h"

@interface TTPDepMsgViewController ()
@end

@implementation TTPDepMsgViewController {
	TTPSharedSettingsController *_settings;
	TTPParser *_parser;
}

- (void)viewDidLoad;
{
    [super viewDidLoad];
	_settings = [TTPSharedSettingsController sharedController];
	self.title = NSLocalizedString(@"Department message", nil);
	
	MBProgressHUD *loadingView = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:loadingView];
	loadingView.delegate = self;
	loadingView.labelText = NSLocalizedString(@"Loading department message", nil);
	[loadingView show:YES];
	
	dispatch_queue_t downloadQueue = dispatch_queue_create("downloader", NULL);
    dispatch_async(downloadQueue, ^{
		NSString *msgURL = [NSString
						   stringWithFormat:@"http://api.ssutt.org:8080/1/department/%@/msg",
						   _settings.selectedGroup.departmentTag];
							
		ShowNetworkActivityIndicator();
		NSURLRequest *request = CreateRequest(msgURL);
		
		NSHTTPURLResponse *response = nil;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request
											 returningResponse:&response
														 error:&error];
		dispatch_async(dispatch_get_main_queue(), ^{
			_parser = [[TTPParser alloc] init];
						
			if (response.statusCode != 200) {
				[self showErrAlert:data error:error messageURL:msgURL response:response];
			}
			else {
				NSString *result = [_parser parseDownloadedMessageForDepartment:data error:error];
				self.departmentMessageView.font = [UIFont fontWithName:@"HelveticeNeue-Light" size:14.0f];
				self.departmentMessageView.text = result;				
				}
			[loadingView hide:YES];
			HideNetworkActivityIndicator();
        });
    });

}

- (void)didReceiveMemoryWarning;
{
    [super didReceiveMemoryWarning];
}

- (IBAction)menuBtnPressed:(id)sender
{
	OpenMenu();
}

- (void)showErrAlert:(NSData *)data error:(NSError *)error messageURL:(NSString *)msgURL response:(NSHTTPURLResponse *)response
{
	NSString *errorData = [[NSString alloc] init];
	if (data != nil)
		errorData = [_parser parseError:data error:error];
	NSString *title = NSLocalizedString(@"Something bad happened!", nil);
	
	NSString *msg;
	if (response.statusCode)
		msg = [NSString stringWithFormat:NSLocalizedString(@"Please report the following error and restart the app:\n%@ at %@(%@) with %d", nil),
					 errorData, _settings.selectedGroup.departmentTag, msgURL, response.statusCode];
	else
		msg = NSLocalizedString(@"Network seems to be down. Please, turn on cellular connection or Wi-Fi", nil);
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle: title																message: msg
													delegate: nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
}

@end
