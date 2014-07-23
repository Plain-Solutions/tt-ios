//
//  TTPMainViewController.m
//  Timetables
//
//  Created by Vladislav Slepukhin on 23/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import "TTPMainViewController.h"
#import "MVYSideMenuController.h"
#import "TTPDepartmentViewController.h"

@interface TTPMainViewController ()

@end

@implementation TTPMainViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	if (![defaults boolForKey:@"wasCfgd"]) {
		NSString *alertTitle = NSLocalizedString(@"Announcement!", nil);
		NSString *alertMessage = NSLocalizedString(@"It seems that you are running Timetables for the first time! Choose your department and group.", nil);
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle: alertTitle
														message: alertMessage
													   delegate: nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		
		[alert show];
		TTPDepartmentViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"DepView"];
		[self.navigationController pushViewController:controller animated:YES];
	}
	
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)menuBtnTapped:(id)sender {
	
	MVYSideMenuController *sideMenuController = [self sideMenuController];
	if (sideMenuController) {
		[sideMenuController openMenu];
	}
}
@end
