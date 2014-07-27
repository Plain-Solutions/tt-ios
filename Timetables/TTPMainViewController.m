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
	
	self.title = @"Loading";
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(updateDay:)
												 name:@"updateDayLabelCalled"
											   object:nil];

	[self.paritySelector setTitle:NSLocalizedString(@"Even", nil) forSegmentAtIndex:0];
	[self.paritySelector setTitle:NSLocalizedString(@"Odd", nil) forSegmentAtIndex:1];
	[self.paritySelector addTarget:self
							action:@selector(parityUpdated:forEvent:)
				  forControlEvents:UIControlEventValueChanged];
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

- (void)updateDay:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"updateDayLabelCalled"]){
		NSInteger num = [[notification object] integerValue];
		self.title = [self convertNumToDays:num];
	}
}

- (NSString *)convertNumToDays:(NSInteger)num;
{
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale preferredLanguages] objectAtIndex:0]]];
	
	NSArray *weekdays = [df weekdaySymbols];
	if (num + 1 >= 7)
		num = 0;
	return [[weekdays objectAtIndex:num + 1] capitalizedString];
	
}

- (void)parityUpdated:(id)sender forEvent:(UIEvent *)event;
{
	NSLog(@"ParityUpdated sent");
	[[NSNotificationCenter defaultCenter] postNotificationName:@"parityUpdated"
														object:	[NSNumber numberWithInt:self.paritySelector.selectedSegmentIndex]];
}


- (IBAction)menuBtnTapped:(id)sender {
	
	MVYSideMenuController *sideMenuController = [self sideMenuController];
	if (sideMenuController) {
		[sideMenuController openMenu];
	}
}
@end
