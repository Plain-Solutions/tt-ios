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

@interface TTPDepMsgViewController ()
@property (nonatomic, strong) TTPParser *parser;
@end

@implementation TTPDepMsgViewController

- (void)viewDidLoad;
{
    [super viewDidLoad];
	dispatch_queue_t downloadQueue = dispatch_queue_create("downloader", NULL);
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	NSString *depTag = ((TTPGroup *)[NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"selectedGroup"]]).departmentTag;
	
	
	MBProgressHUD *loadingView = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:loadingView];
	loadingView.delegate = self;
	
	loadingView.labelText = NSLocalizedString(@"Loading departments info", nil);
	[loadingView show:YES];
	
	
	
    dispatch_async(downloadQueue, ^{
		NSString *msgURL = [NSString
						   stringWithFormat:@"http://api.ssutt.org:8080/1/department/%@/msg",
						   depTag];
							
		ShowNetworkActivityIndicator();
		NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: msgURL]
												 cachePolicy:NSURLRequestUseProtocolCachePolicy
											 timeoutInterval:120];
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
				
				NSString *msg = [NSString stringWithFormat:@"Please report the following error and restart the app:\n%@ at %@(%@) with %d",
								 errorData, depTag, msgURL, response.statusCode];
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Something bad happended!"
																message: msg
															   delegate: nil
													  cancelButtonTitle:@"OK"
													  otherButtonTitles:nil];
				[alert show];
			}
			else {
				NSString *result = [self.parser parseDownloadedMessageForDepartment:data error:error];
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

- (IBAction)menuBtnPressed:(id)sender {
	
	MVYSideMenuController *sideMenuController = [self sideMenuController];
	if (sideMenuController) {
		[sideMenuController openMenu];
	}

}
@end
