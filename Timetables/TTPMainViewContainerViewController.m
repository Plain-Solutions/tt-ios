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

@interface TTPMainViewContainerViewController ()
@property (readonly, strong, nonatomic) TTPTimetableModelController *modelController;
@property (strong, nonatomic) TTPTimetableAccessor *timetableAccessor;
@end

@implementation TTPMainViewContainerViewController

@synthesize modelController = _modelController;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	dispatch_queue_t downloadQueue = dispatch_queue_create("myDownloadQueue",NULL);
	dispatch_async(downloadQueue, ^
				   {
					   NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
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
											  [self.timetableAccessor populateAvailableDays];
											  //=============
											  											  
											  // PageView
											  self.timetableViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:50.0f] forKey:UIPageViewControllerOptionInterPageSpacingKey]];
											  self.timetableViewController.delegate = self;
											  self.timetableViewController.dataSource = self.modelController;
											  
											  TTPTimetableDataViewController *startingViewController = [self.modelController
																										viewControllerAtIndex:self.timetableAccessor.firstAvailableDay storyboard:self.storyboard];
											  NSArray *viewControllers = @[startingViewController];
											  
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
																																
											  HideNetworkActivityIndicator();
										  }

									  });});
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (TTPTimetableModelController *)modelController
{
	// Return the model controller object, creating it if necessary.
	// In more complex implementations, the model controller may be passed to the view controller.
    if (!_modelController) {
        _modelController = [[TTPTimetableModelController alloc] init];
		self.modelController.accessor = self.timetableAccessor;
    }
    return _modelController;
}
@end
