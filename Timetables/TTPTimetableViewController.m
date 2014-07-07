//
//  TTPTimetableViewController.m
//  Timetables
//
//  Created by Vladislav Slepukhin on 30/06/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import "TTPTimetableViewController.h"

@interface TTPTimetableViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) TTPParser *parser;
@property (nonatomic, strong) TTPTimetableAccessor *timetableAccessor;
@end

@implementation TTPTimetableViewController

@synthesize selectedDepartment = _selectedDepartment;
@synthesize selectedGroup = _selectedGroup;
@synthesize dayLessons = _dayLessons;

@synthesize parser = _parser;
@synthesize timetableAccessor = _timetableAccessor;

@synthesize paritySelector = _paritySelector;
@synthesize daySelector = _daySelector;
@synthesize timetable = _timetable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewDidLoad;
{
	if (self.selectedGroup == nil) {
	self.selectedGroup = @"151";
	TTPDepartment *testDep = [[TTPDepartment alloc] init];
	testDep.name = @"KNIIT";
	testDep.tag=  @"knt";
	self.selectedDepartment = testDep;
	}
	// UI
	[[self navigationController] setNavigationBarHidden:YES animated:YES];
    self.timetable.delegate = self;
	self.timetable.dataSource = self;
	[self.view addSubview:self.timetable];
	[self.paritySelector addTarget:self
							action:@selector(parityUpdated:forEvent:)
				  forControlEvents:UIControlEventValueChanged];
	// gestures
	UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self
																					action:@selector(handleSwipeL)];
	leftSwipe.numberOfTouchesRequired = 1;
	leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
	[self.view addGestureRecognizer:leftSwipe];
	
	UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self
																					 action:@selector(handleSwipeR)];
	rightSwipe.numberOfTouchesRequired = 1;
	rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
	[self.view addGestureRecognizer:rightSwipe];

	[super viewDidLoad];

	// downloading
	dispatch_queue_t downloadQueue = dispatch_queue_create("downloader", NULL);
    dispatch_async(downloadQueue, ^{
		NSString *ttURL = [NSString
						   stringWithFormat:@"http://api.ssutt.org:8080/2/department/%@/group/%@",
						   self.selectedDepartment.tag,
						   [self.selectedGroup stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

		ShowNetworkActivityIndicator();
		NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: ttURL]
												 cachePolicy:NSURLRequestUseProtocolCachePolicy
											 timeoutInterval:120];
		NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request
											 returningResponse:&response
														 error:&error];

		dispatch_async(dispatch_get_main_queue(), ^{
			self.parser = [[TTPParser alloc] init];
			self.timetableAccessor = [[TTPTimetableAccessor alloc] init];
			self.timetableAccessor.timetable = [self.parser parseTimetables:data
																	  error:error];
			[self.timetableAccessor populateAvailableDays];
			
			self.dayLessons = [self.timetableAccessor getLessonsOnDayParity:
							   self.timetableAccessor.firstAvailableDay
																	 parity:[NSNumber numberWithInt:0]
																withRepeats:NO];
			
			self.daySelector.currentPage = [self.timetableAccessor.firstAvailableDay intValue];
			self.daynameLabel.text = [self convertNumToDays:[NSNumber numberWithInt:self.daySelector.currentPage]];
			[self.timetable reloadData];
			HideNetworkActivityIndicator();
        });
    });
}

- (void)didReceiveMemoryWarning;
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated;
{
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:YES];
	[self.timetable reloadData];
}

#pragma mark - Timetable
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
	return self.dayLessons.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    TTPSubjectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LessonCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[TTPSubjectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LessonCell"];
    }
	if (self.dayLessons.count != 0){
	TTPLesson *lesson = [self.dayLessons objectAtIndex:indexPath.row];

	cell.subjectNameLabel.text = lesson.name;
	cell.subjectTypeLabel.text =[self.timetableAccessor localizeActivities:lesson.activity];
	cell.beginTimeLabel.text = [self.timetableAccessor getBeginTimeBySequence:lesson.sequence];
	cell.endTimeLabel.text = [self.timetableAccessor getEndTimeBySequence:lesson.sequence];
	cell.locationLabel.text= [self.timetableAccessor getLocationOnSingleSubgroupCount:lesson.subgroups];
	}
    return cell;
}

#pragma mark - Actions
- (void)handleSwipeL;
{
	self.daySelector.currentPage = [[self.timetableAccessor getNextDay:self.daySelector.currentPage] intValue];
	self.dayLessons = [self.timetableAccessor getLessonsOnDayParity:
					   [NSNumber numberWithInt: self.daySelector.currentPage]
															 parity:[NSNumber numberWithInt:self.paritySelector.selectedSegmentIndex]
														withRepeats:NO];
	self.daynameLabel.text = [self convertNumToDays: [NSNumber numberWithInt:self.daySelector.currentPage]];

	[self.timetable reloadData];
}

- (void)handleSwipeR;
{

	self.daySelector.currentPage = [[self.timetableAccessor getPreviousDay:self.daySelector.currentPage] intValue];

	self.dayLessons = [self.timetableAccessor getLessonsOnDayParity:
					   [NSNumber numberWithInt: self.daySelector.currentPage]
															 parity:[NSNumber numberWithInt:self.paritySelector.selectedSegmentIndex]
														withRepeats:NO];
	
	self.daynameLabel.text = [self convertNumToDays: [NSNumber numberWithInt:self.daySelector.currentPage]];
	
	[self.timetable reloadData];
	
}

- (void)parityUpdated:(id)sender forEvent:(UIEvent *)event;
{
	[self.dayLessons removeAllObjects];
    self.dayLessons = [self.timetableAccessor getLessonsOnDayParity:
					   [NSNumber numberWithInt: self.daySelector.currentPage]
															 parity:[NSNumber numberWithInt:self.paritySelector.selectedSegmentIndex]
														withRepeats:NO];

	[self.timetable reloadData];
}

#pragma  mark - Private stuff

- (NSString *)convertNumToDays:(NSNumber *)num;
{
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale preferredLanguages] objectAtIndex:0]]];

	NSArray *weekdays = [df weekdaySymbols];
	if ([num intValue] +1 >= 7)
		num = [NSNumber numberWithInt:0];
	return [[weekdays objectAtIndex:[num intValue] +1] capitalizedString];

}

- (void)updateDisplay:(NSString *)str;
{
	
	[self.daynameLabel performSelectorOnMainThread : @selector(setText : ) withObject:str waitUntilDone:YES];
}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"discloseSubjectDetails"]) {
		TTPSubjectDetailTableViewController *controller = [segue destinationViewController];
        controller.selectedLesson = [self.dayLessons objectAtIndex:[self.timetable indexPathForSelectedRow].row];
        controller.accessor = self.timetableAccessor;
    }
}


- (IBAction)searchGroups:(id)sender;
{
	UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SearchViews" bundle:nil];
	UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"selectDepView"];
//	self.nacontroller = [[UINavigationController alloc] initWithRootViewController:vc];
	vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self.navigationController pushViewController:vc animated:YES];
}
@end
