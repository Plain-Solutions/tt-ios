//
//  TTPDepMsgViewController.m
//  Timetables
//
//  Created by Vladislav Slepukhin on 08/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import "TTPDepMsgViewController.h"

@interface TTPDepMsgViewController ()
@property (nonatomic, strong) TTPParser *parser;
@end

@implementation TTPDepMsgViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {

    }
    return self;
}

- (void)viewDidLoad;
{
    [super viewDidLoad];
	
	dispatch_queue_t downloadQueue = dispatch_queue_create("downloader", NULL);
    dispatch_async(downloadQueue, ^{
		NSString *msgURL = [NSString
						   stringWithFormat:@"http://api.ssutt.org:8080/1/department/%@/msg",
						   self.departmentTag];
							
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
				
				NSString *msg = [NSString stringWithFormat:@"Please report the following error and restart the app:\n%@ at %@(%@)",
								 errorData, self.departmentTag, msgURL];
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Something bad happended!"
																message: msg
															   delegate: nil
													  cancelButtonTitle:@"OK"
													  otherButtonTitles:nil];
				[alert show];
			}
			else {
				NSString *result = [self.parser parseDownloadedMessageForDepartment:data error:error];
				if ([self.departmentTag isEqualToString:@"ifg"])
					result = [NSString stringWithFormat:@"%@\nBest wishes to lovely ADCh from fau!", result];
				self.departmentMessageView.text = result;

			}
			HideNetworkActivityIndicator();
        });
    });

}

- (void)didReceiveMemoryWarning;
{
    [super didReceiveMemoryWarning];
}

@end
