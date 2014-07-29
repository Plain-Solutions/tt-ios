//
//  TTPMainViewContainerViewController.m
//  Timetables
//
//  Created by Vladislav Slepukhin on 23/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import "TTPMainViewContainerViewController.h"
#import "TTPTimetableModelController.h"
#import "TTPTimetableDataViewController.h"
#import "TTPGroup.h"
#import "TTPParser.h"
#import "TTPTimetableAccessor.h"

struct StartingDP {
	NSInteger day;
	NSInteger parity;
};


@interface TTPMainViewContainerViewController ()
@property (readonly, strong, nonatomic) TTPTimetableModelController *modelController;
@property (strong, nonatomic) TTPTimetableAccessor *timetableAccessor;
@end

@implementation TTPMainViewContainerViewController {
	struct StartingDP _startingDP;
}

@synthesize modelController = _modelController;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

//  This will be added in the next version
//	[[NSNotificationCenter defaultCenter] addObserver:self
//											 selector:@selector(updateDayTapped:) name:@"updateDayButtonTapped"
//											   object:nil];
	
	
	
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if ([defaults objectForKey:@"selectedGroup"] || [defaults objectForKey:@"myGroup"]) {
		if (![defaults objectForKey:@"selectedGroup"])
			[defaults setObject:[defaults objectForKey:@"myGroup"] forKey:@"selectedGroup"];
		
		MBProgressHUD *loadingView = [[MBProgressHUD alloc] initWithView:self.view];
		[self.view addSubview:loadingView];
		loadingView.delegate = self;

		loadingView.labelText = NSLocalizedString(@"Loading schedule", nil);
		[loadingView show:YES];
	
		dispatch_queue_t downloadQueue = dispatch_queue_create("myDownloadQueue",NULL);
		dispatch_async(downloadQueue, ^
					   {

						   TTPGroup *selectedGroup = [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"selectedGroup"]];


						   NSString *ttURL = [NSString
											  stringWithFormat:@"http://api.ssutt.org:8080/2/department/%@/group/%@",
											  selectedGroup.departmentTag,
											  [selectedGroup.groupName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
						   
						   ShowNetworkActivityIndicator();

						   NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: ttURL]
																	cachePolicy:NSURLRequestUseProtocolCachePolicy
																timeoutInterval:120];
						   NSHTTPURLResponse *response = nil;
						   NSError *error = nil;
						   NSData *data = [NSURLConnection sendSynchronousRequest:request
																returningResponse:&response
																			error:&error];
						   
						   dispatch_async(dispatch_get_main_queue(), ^
										  {
											  TTPParser *parser = [[TTPParser alloc] init];
											  if (response.statusCode != 200) {
												  NSString *errorData = [[NSString alloc] init];
												  if (data != nil)
													  errorData = [parser parseError:data error:error];
												  
												  NSString *msg = [NSString stringWithFormat:NSLocalizedString(@"Please report the following error and restart the app:\n%@ at %@/%@(%@) with %d", nil),
																   errorData, selectedGroup.departmentTag, selectedGroup.groupName, ttURL, response.statusCode];
												  UIAlertView *alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Something bad happened!", nil)
																								  message: msg
																								 delegate: nil
																						cancelButtonTitle:@"OK"
																						otherButtonTitles:nil];
												  [alert show];
												  
											  }
											  else {																						
												  //TT ACCESSOR
												  self.timetableAccessor = [[TTPTimetableAccessor alloc] init];
												  self.timetableAccessor.timetable = [parser parseTimetables:data
																									   error:error];
												  if (self.timetableAccessor.timetable.count) {
												  [self.timetableAccessor populateAvailableDays];
												  [self setStartingDayParity];
												  //=============
																							  
												  // PageView
												  self.timetableViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:50.0f] forKey:UIPageViewControllerOptionInterPageSpacingKey]];
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
													  self.view.gestureRecognizers = self.timetableViewController.gestureRecognizers;}
												  else {
													  NSString *msg = NSLocalizedString(@"No timetable information available in SSU database. Please address your dean office to resolve this issue", nilw);
													  UIAlertView *alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Something bad happened!", nil)
																									  message: msg
																									 delegate: nil
																							cancelButtonTitle:@"OK"
																							otherButtonTitles:nil];
													  [alert show];
													  
												  }
												  [loadingView hide:YES];
												  HideNetworkActivityIndicator();
											  }

									  });});
	}
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)setStartingDayParity;
{
	_startingDP.parity = 0;
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	[gregorian setLocale:[[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale preferredLanguages] objectAtIndex:0]]];
	[gregorian setFirstWeekday:2];
	NSUInteger weekday = [gregorian ordinalityOfUnit:NSWeekdayCalendarUnit inUnit:NSWeekCalendarUnit forDate:[NSDate date]];
	weekday--;
	if (![self.timetableAccessor lessonsCountOnDayParity:weekday parity:0]) {
		if (![self.timetableAccessor lessonsCountOnDayParity:weekday parity:1]) {
			NSUInteger wday = weekday;
			while (![self.timetableAccessor lessonsCountOnDayParity:weekday parity:0] && weekday <= 5) {
				weekday++;
			}
			if (weekday > 5) {
				weekday = wday;
				while (![self.timetableAccessor lessonsCountOnDayParity:weekday parity:1] && weekday <= 5) {
					weekday++;
				}
			}
			
		}
		else {
			_startingDP.parity = 1;
		}
	}
	
	_startingDP.day = weekday;
}
- (TTPTimetableModelController *)modelController
{
    if (!_modelController) {
        _modelController = [[TTPTimetableModelController alloc] init];
		self.modelController.accessor = self.timetableAccessor;
    }
    return _modelController;
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
