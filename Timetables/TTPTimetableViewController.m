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
	self.defaults = [NSUserDefaults standardUserDefaults];
	
	if (self.selectedGroup == nil) {
		NSData *data = [self.defaults objectForKey:@"myGroup"];
		self.selectedGroup = [NSKeyedUnarchiver unarchiveObjectWithData:data];		
	}
	
	NSData *data = [self.defaults objectForKey:@"savedGroups"];
	NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//	self.addGroup.enabled = !([self.selectedGroup isSaved:arr]);
	
	
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
			
			self.daySelector.currentPage = self.timetableAccessor.firstAvailableDay;
			self.daynameLabel.text = [self convertNumToDays:self.daySelector.currentPage];
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
	NSArray *seqs = [self.timetableAccessor availableSequencesOnDayParity:self.daySelector.currentPage
																   parity:self.paritySelector.selectedSegmentIndex];

	return [self.timetableAccessor lessonsCountOnDayParitySequence:self.daySelector.currentPage
															parity:self.paritySelector.selectedSegmentIndex
														   sequence:[[seqs objectAtIndex:section] integerValue]];


}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [self.timetableAccessor lessonsCountOnDayParity:self.daySelector.currentPage
													parity:self.paritySelector.selectedSegmentIndex];
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return 3;
    return 0.5;
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
	
	cell.subjectNameLabel.text = [NSString stringWithFormat:@"%@%@",[[subj.name substringToIndex:1] uppercaseString], [subj.name substringFromIndex:1]];
	
	
	cell.subjectTypeLabel.text =[self.timetableAccessor localizeActivities:subj.activity];
	cell.locationLabel.text= [self.timetableAccessor locationOnSingleSubgroupCount:subj.subgroups];

	if ([subjectsDPT indexOfObject:subj] == 0) {

		cell.beginTimeLabel.text = [self.timetableAccessor beginTimeBySequence:sequence];
		cell.endTimeLabel.text = [self.timetableAccessor endTimeBySequence:sequence];
		cell.dashLabel.text =@"–––";
	}
	else cell.beginTimeLabel.text = cell.endTimeLabel.text = cell.dashLabel.text =@"";
	
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

- (void)updateDisplay:(NSString *)str;
{
	
	[self.daynameLabel performSelectorOnMainThread : @selector(setText : ) withObject:str waitUntilDone:YES];
}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
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
}


- (IBAction)addGroup:(id)sender;
{
	NSData *data = [self.defaults objectForKey:@"savedGroups"];
	
	NSMutableArray *savedGroups = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
	TTPGroup *grp = [self.selectedGroup copy];	
	[savedGroups addObject:grp];
	
	NSData *updatedData = [NSKeyedArchiver archivedDataWithRootObject:savedGroups];
	[self.defaults setObject:updatedData forKey:@"savedGroups"];
	[self.defaults synchronize];

}

- (IBAction)searchGroups:(id)sender;
{
	UIStoryboard *searchStoryboard = [UIStoryboard storyboardWithName:@"SearchViews" bundle:nil];
	UIViewController *controller = [searchStoryboard instantiateViewControllerWithIdentifier:@"selectDepView"];
	
	[self.navigationController pushViewController:controller animated:YES];
}
@end
