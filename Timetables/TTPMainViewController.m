//
//  TTPMainViewController.m
//  Timetables
//
//  Created by Vladislav Slepukhin on 23/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import "TTPMainViewController.h"


@interface TTPMainViewController ()
@end

@implementation TTPMainViewController {
	TTPSharedSettingsController *_settings;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	_settings = [TTPSharedSettingsController sharedController];
	self.title = NSLocalizedString(@"Loading", nil);

	SetMenuButton();
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"star-25"] style:UIBarButtonItemStyleBordered target:self action:@selector(addGroupToFavs)];
	
	if (!_settings.wasCfgd) {
		[self showNoMyGroupAlert];
		
		TTPDepartmentViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"DepView"];
		[self.navigationController pushViewController:controller animated:YES];
	}
	
	if ([_settings.selectedGroup isEqualTo:_settings.myGroup]) {
		[self.navigationItem setRightBarButtonItem:nil animated:NO];
	}
	else
		for (TTPGroup *g in _settings.savedGroups) {
			if ([_settings.selectedGroup isEqualTo:g])
				{
					[self.navigationItem setRightBarButtonItem:nil animated:NO];
					break;
				}
			else self.navigationItem.rightBarButtonItem.enabled = YES;
		}
	
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(updateDay:)
												 name:@"updateDayLabelCalled"
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(parityUpdateRequest:) name:@"parityUpdateRequest"
											   object:nil];


	[self.paritySelector setTitle:NSLocalizedString(@"Even", nil) forSegmentAtIndex:0];
	[self.paritySelector setTitle:NSLocalizedString(@"Odd", nil) forSegmentAtIndex:1];
	[self.paritySelector addTarget:self
							action:@selector(parityUpdated:forEvent:)
				  forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (void)addGroupToFavs {
	[_settings addSelectedGroupToFavorites];
	[self.navigationItem setRightBarButtonItem:nil animated:YES];
}

#pragma mark - Conversion

- (NSString *)convertNumToDays:(NSInteger)num
{
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale preferredLanguages] objectAtIndex:0]]];
	
	NSArray *weekdays = [df weekdaySymbols];
	if (num + 1 >= 7)
		num = 0;
	return [[weekdays objectAtIndex:num + 1] capitalizedString];
	
}

#pragma mark - Notifications

- (void)updateDay:(NSNotification *)notification
{
	if ([[notification name] isEqualToString:@"updateDayLabelCalled"]){
		NSInteger num = [[notification object] integerValue];
		self.title = [self convertNumToDays:num];
	}
}

- (void)parityUpdated:(id)sender forEvent:(UIEvent *)event
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"parityUpdated"
														object:	[NSNumber numberWithInt:self.paritySelector.selectedSegmentIndex]];
}

- (void)parityUpdateRequest:(NSNotification *)notification
{
	if ([[notification name] isEqualToString:@"parityUpdateRequest"])
		[[NSNotificationCenter defaultCenter] postNotificationName:@"parityUpdated"
															object:	[NSNumber numberWithInt:self.paritySelector.selectedSegmentIndex]];
}

#pragma mark - Navigation

- (IBAction)menuBtnTapped:(id)sender
{
	OpenMenu();
}

#pragma mark - Alerts

- (void)showNoMyGroupAlert
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



@end
