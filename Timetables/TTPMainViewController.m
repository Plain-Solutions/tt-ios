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
#import "TTPGroup.h"

@interface TTPMainViewController ()

@end

@implementation TTPMainViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu-25"]
style:UIBarButtonItemStyleBordered target:self action:@selector(menuBtnTapped:)];
	if (![defaults boolForKey:@"wasCfgd"]) {
		[self showNoMyGroupAlert];
		
		TTPDepartmentViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"DepView"];
		[self.navigationController pushViewController:controller animated:YES];
	}
	else {
		if ([defaults objectForKey:@"selectedGroup"] == nil)
			[defaults setObject:[defaults objectForKey:@"myGroup"] forKey:@"selectedGroup"];
		TTPGroup *grp =[NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"selectedGroup"]];
		self.title = [NSString stringWithFormat:@"%@ %@", grp.departmentTag, grp.groupName];
		}
}

- (void)showNoMyGroupAlert;
{
	NSString *alertTitle = NSLocalizedString(@"Announcement!", nil);
	NSString *alertMessage = NSLocalizedString(@"It seems that you are running Timetables for the first time! Choose your department and group.", nil);
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle: alertTitle
													message: alertMessage
												   delegate: nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	
	[alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)menuBtnTapped:(id)sender {
	
	MVYSideMenuController *sideMenuController = [self sideMenuController];
	if (sideMenuController) {
		[sideMenuController openMenu];
	}
}
@end
