//
//  TTPMainViewContainerViewController.m
//  Timetables
//
//  Created by Vladislav Slepukhin on 23/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import "TTPMainViewContainerViewController.h"

@interface TTPMainViewContainerViewController ()
@property (readonly, strong, nonatomic) TTPTimetableModelController *modelController;
@end

@implementation TTPMainViewContainerViewController {
	struct __dayParityEntity _startingDP;
	
	TTPSharedSettingsController *_settings;
	TTPTimetableAccessor *_accessor;
	TTPParser *_parser;
}

@synthesize modelController = _modelController;

- (void)viewDidLoad
{
    [super viewDidLoad];
	_settings = [TTPSharedSettingsController sharedController];

	//  This will be added in the next version
//	[[NSNotificationCenter defaultCenter] addObserver:self
//											 selector:@selector(updateDayTapped:) name:@"updateDayButtonTapped"
//											   object:nil];
	if (_settings.selectedGroup) {
		
		MBProgressHUD *loadingView = [[MBProgressHUD alloc] initWithView:self.view];
		[self.view addSubview:loadingView];
		loadingView.delegate = self;
		loadingView.labelText = NSLocalizedString(@"Loading schedule", nil);
		[loadingView show:YES];
	
		dispatch_queue_t downloadQueue = dispatch_queue_create("myDownloadQueue",NULL);
		dispatch_async(downloadQueue, ^
					   {


						   NSString *timetableURL = [NSString
											  stringWithFormat:@"http://api.ssutt.org:8080/2/department/%@/group/%@",
											  _settings.selectedGroup.departmentTag,
											  [_settings.selectedGroup.groupName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
						   
						   ShowNetworkActivityIndicator();

						   NSURLRequest *request = CreateRequest(timetableURL);
						   
						   NSHTTPURLResponse *response = nil;
						   NSError *error = nil;
						   NSData *data = [NSURLConnection sendSynchronousRequest:request
																returningResponse:&response
																			error:&error];
						   
						   dispatch_async(dispatch_get_main_queue(), ^
										  {
											  _parser = [[TTPParser alloc] init];
											  if (response.statusCode != 200) {
												  [self showErrorAlert:data
																 error:error
																   url:timetableURL
															  response:response];
												  
											  }
											  else {																						
												  //TT ACCESSOR
												  _accessor = [[TTPTimetableAccessor alloc] init];
												  _accessor.timetable = [_parser parseTimetables:data
																									   error:error];
												  [loadingView hide:YES];
												  HideNetworkActivityIndicator();
												  if (_accessor.timetable.count)
													  [self setupMainView];
												  else
													  [self showEmptyTimetableAlert];
												  
												}
									  });});
	}
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Accessors
- (TTPTimetableModelController *)modelController
{
    if (!_modelController) {
        _modelController = [[TTPTimetableModelController alloc] init];
		self.modelController.accessor = _accessor;
    }
    return _modelController;
}

#pragma mark - Private Actions
- (void)setupMainView
		{
			[_accessor populateAvailableDays];
			[self setStartingDayParity];
			//=============
			
			// PageView
			self.timetableViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:30.0f] forKey:UIPageViewControllerOptionInterPageSpacingKey]];
			self.timetableViewController.view.backgroundColor = TableViewColor;
			self.timetableViewController.delegate = self;
			self.timetableViewController.dataSource = self.modelController;
			
			TTPTimetableDataViewController *startingViewController = [self.modelController
																	  viewControllerAtIndex:_startingDP.day storyboard:self.storyboard];
			NSArray *viewControllers = @[startingViewController];
			startingViewController.parity = _startingDP.parity;
			
			[self.timetableViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
			
			// ===================
			// UI/UX
			[self addChildViewController:self.timetableViewController];
			[self.view addSubview:self.timetableViewController.view];
			
			// Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
			CGRect pageViewRect = self.view.bounds;
			self.timetableViewController.view.frame = pageViewRect;
			
			[self.timetableViewController didMoveToParentViewController:self];
			
			// Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
			self.view.gestureRecognizers = self.timetableViewController.gestureRecognizers;

}

- (void)setStartingDayParity;
{
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	[gregorian setLocale:[[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale preferredLanguages] objectAtIndex:0]]];
	[gregorian setFirstWeekday:2];
	NSUInteger weekday = [gregorian ordinalityOfUnit:NSWeekdayCalendarUnit inUnit:NSWeekCalendarUnit forDate:[NSDate date]];
	weekday--;
	// Sunday case
	struct __dayParityEntity dpe;
	[[_accessor.availableDays firstObject] getValue:&dpe];
	if (weekday == 6) {
		_startingDP.day = dpe.day;
		_startingDP.parity = dpe.parity;
	}
	else {
		struct __dayParityEntity dpe;
		
		BOOL todayEmpty = YES;
		for (int i = 0; i < _accessor.availableDays.count; i++) {
			[_accessor.availableDays[i] getValue:&dpe];
			if (dpe.day == weekday) {
				todayEmpty = NO;
				_startingDP.day = dpe.day;
				_startingDP.parity = dpe.parity;
				break;
			}
		}
		if (todayEmpty) {
			BOOL exit = NO;
			while (!exit) {
				weekday++;
				if (weekday == 6) weekday = 0;
				for (int i = 0; i < _accessor.availableDays.count; i++) {
					[_accessor.availableDays[i] getValue:&dpe];
					if (dpe.day == weekday) {
						exit = YES;
						_startingDP.day = dpe.day;
						_startingDP.parity = dpe.parity;
						break;
					}
				}
			}
		}
	}
}

#pragma mark - Alerts

- (void)showErrorAlert:(NSData *)data error:(NSError *)error url:(NSString *)timetableURL response:(NSHTTPURLResponse *)response
{
	NSString *errorData = [[NSString alloc] init];
	if (data != nil)
		errorData = [_parser parseError:data error:error];
	NSString *title = NSLocalizedString(@"Something bad happened!", nil);
	
	NSString *msg;
	if (response.statusCode)
		msg = [NSString stringWithFormat:NSLocalizedString(@"Please report the following error and restart the app:\n%@ at %@/%@(%@) with %d", nil),
					 errorData, _settings.selectedGroup.departmentTag, _settings.selectedGroup.groupName, timetableURL, response.statusCode];
	else
		msg = NSLocalizedString(@"Network seems to be down. Please, turn on cellular connection or Wi-Fi", nil);

	UIAlertView *alert = [[UIAlertView alloc] initWithTitle: title
													message: msg
												   delegate: nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
}

- (void)showEmptyTimetableAlert
{
	NSString *msg = NSLocalizedString(@"No timetable information available in SSU database. Please address your dean office to resolve this issue", nil);
	NSString *title = NSLocalizedString(@"Something bad happened!", nil);
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle: title
													message: msg
												   delegate: nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
}

// For the next release
//- (void)updateDayTapped:(NSNotification *)notification
//{
//	NSInteger day = [[notification object] integerValue];
//	TTPTimetableDataViewController *startingViewController = [self.modelController
//															  viewControllerAtIndex:day storyboard:self.storyboard];
//	NSArray *viewControllers = @[startingViewController];
//	
//	[self.timetableViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
//	
//
//}
@end
