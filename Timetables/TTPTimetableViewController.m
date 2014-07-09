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
@property (nonatomic, strong) NSUserDefaults *defaults;
@end

@implementation TTPTimetableViewController

@synthesize selectedGroup = _selectedGroup;

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
	// init settings
	self.defaults = [NSUserDefaults standardUserDefaults];
	
	// load user's group if not selected
	if (self.selectedGroup == nil) {
		NSData *data = [self.defaults objectForKey:@"myGroup"];
		self.selectedGroup = [NSKeyedUnarchiver unarchiveObjectWithData:data];		
	}

	// UI init
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
						   self.selectedGroup.departmentTag,
						   [self.selectedGroup.groupName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

		ShowNetworkActivityIndicator();
		NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: ttURL]
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
				
				NSString *msg = [NSString stringWithFormat:NSLocalizedString(@"Please report the following error and restart the app:\n%@ at %@/%@(%@) with %d", nil),
								 errorData, self.selectedGroup.departmentTag, self.selectedGroup.groupName, ttURL, response.statusCode];
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Something bad happened!", nil)
																message: msg
															   delegate: nil
													  cancelButtonTitle:@"OK"
													  otherButtonTitles:nil];
				[alert show];
			}
			else {
			
			self.timetableAccessor = [[TTPTimetableAccessor alloc] init];
			self.timetableAccessor.timetable = [self.parser parseTimetables:data
																	  error:error];
			[self.timetableAccessor populateAvailableDays];

			self.daySelector.currentPage = [self getStartingDay];
			self.daynameLabel.text = [self convertNumToDays:self.daySelector.currentPage];
			[self.timetable reloadData];
			}
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
	NSArray *seqs = [self.timetableAccessor availableSequencesOnDayParity:self.daySelector.currentPage
																   parity:self.paritySelector.selectedSegmentIndex];

	return [self.timetableAccessor lessonsCountOnDayParitySequence:self.daySelector.currentPage
															parity:self.paritySelector.selectedSegmentIndex
														   sequence:[[seqs objectAtIndex:section] integerValue]];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
	return [self.timetableAccessor lessonsCountOnDayParity:self.daySelector.currentPage
													parity:self.paritySelector.selectedSegmentIndex];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    if (section == 0)
        return 1.5;
    return 0.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    TTPSubjectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LessonCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[TTPSubjectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LessonCell"];
    }
	
	NSArray *seqs = [self.timetableAccessor availableSequencesOnDayParity:self.daySelector.currentPage
																   parity:self.paritySelector.selectedSegmentIndex];
	NSNumber *sequence = [seqs objectAtIndex:indexPath.section];
	
	NSArray *subjectsDPT = [self.timetableAccessor lessonsOnDayParitySequence:self.daySelector.currentPage
																	   parity:self.paritySelector.selectedSegmentIndex
																	 sequence:[sequence integerValue]];

	TTPSubjectEntity *subj = [subjectsDPT objectAtIndex:indexPath.row];
	

	cell.subjectNameLabel.text = [NSString stringWithFormat:@"%@%@",[[subj.name substringToIndex:1] uppercaseString],
								  [subj.name substringFromIndex:1]];
	cell.subjectTypeLabel.text = NSLocalizedString(subj.activity, nil);
	cell.locationLabel.text= [self.timetableAccessor locationOnSingleSubgroupCount:subj.subgroups];

	if ([subjectsDPT indexOfObject:subj] == 0) {
		cell.beginTimeLabel.text = [self.timetableAccessor beginTimeBySequence:sequence];
		cell.endTimeLabel.text = [self.timetableAccessor endTimeBySequence:sequence];
		cell.dashLabel.text =@"–––";
	}
	else cell.beginTimeLabel.text = cell.endTimeLabel.text = cell.dashLabel.text = @"";
	
	return cell;
}

#pragma mark - Actions
- (void)handleSwipeL;
{
	self.daySelector.currentPage = [self.timetableAccessor nextDay:self.daySelector.currentPage];
	self.daynameLabel.text = [self convertNumToDays:self.daySelector.currentPage];
	[self.timetable reloadData];
}

- (void)handleSwipeR;
{
	self.daySelector.currentPage = [self.timetableAccessor previousDay:self.daySelector.currentPage];
	self.daynameLabel.text = [self convertNumToDays:self.daySelector.currentPage];
	[self.timetable reloadData];
	
}

- (void)parityUpdated:(id)sender forEvent:(UIEvent *)event;
{
	[self.timetable reloadData];
}

#pragma  mark - Private stuff

- (NSString *)convertNumToDays:(NSInteger)num;
{
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale preferredLanguages] objectAtIndex:0]]];

	NSArray *weekdays = [df weekdaySymbols];
	if (num + 1 >= 7)
		num = 0;
	return [[weekdays objectAtIndex:num + 1] capitalizedString];

}

- (NSInteger)getStartingDay;
{
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
			self.paritySelector.selectedSegmentIndex = 1;
		}
	}

	return  weekday;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;
{
	if ([segue.identifier isEqualToString:@"discloseSubjectDetails"]) {
		TTPSubjectCell *cell = (TTPSubjectCell*)sender;
		NSIndexPath *indexPath = [self.timetable indexPathForCell:cell];
		TTPSubjectDetailTableViewController *controller = [segue destinationViewController];
		NSArray *seqs = [self.timetableAccessor availableSequencesOnDayParity:self.daySelector.currentPage
																	   parity:self.paritySelector.selectedSegmentIndex];
		NSNumber *sequence = [seqs objectAtIndex:indexPath.section];
		NSArray *subjectsDPT = [self.timetableAccessor lessonsOnDayParitySequence:self.daySelector.currentPage
																		   parity:self.paritySelector.selectedSegmentIndex
																		 sequence:[sequence integerValue]];
		
		TTPSubjectEntity *subj = [subjectsDPT objectAtIndex:indexPath.row];

        controller.subject = subj;
		controller.sequence = [sequence integerValue];
    }
	if ([segue.identifier isEqualToString:@"viewSavedGroups"]) {
		TTPSavedGroupsViewController *controller = [segue destinationViewController];
		controller.selectedGroup = self.selectedGroup;
	}
}

- (IBAction)searchGroups:(id)sender;
{
	UIStoryboard *searchStoryboard = [UIStoryboard storyboardWithName:@"SearchViews" bundle:nil];
	UIViewController *controller = [searchStoryboard instantiateViewControllerWithIdentifier:@"selectDepView"];
	
	[self.navigationController pushViewController:controller animated:YES];
}
@end
