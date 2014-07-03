//
//  TTPTimetableViewController.m
//  Timetables
//
//  Created by Vladislav Slepukhin on 30/06/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import "TTPTimetableViewController.h"
#import "TTPParser.h"
#import "TTPSubjectCell.h"
#import "TTPTimetableAccessor.h"

@interface TTPTimetableViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) TTPParser *parser;
@property (nonatomic, strong) TTPTimetableAccessor *timetableAccessor;
@end

@implementation TTPTimetableViewController

@synthesize selectedDepartment = _selectedDepartment;
@synthesize selectedGroup = _selectedGroup;
@synthesize dayLessons = _dayLessons;

@synthesize responseData = _responseData;
@synthesize parser = _parser;
@synthesize timetableAccessor = _timetableAccessor;

@synthesize paritySelector = _paritySelector;
@synthesize daySelector = _daySelector;
@synthesize timetable = _timetable;
@synthesize savedGroupsButton = _savedGroupsButton;
@synthesize searchGroupsButton = _searchGroupsButton;



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
 
	//data models

		self.responseData = [NSMutableData data];
	//UI
	[[self navigationController] setNavigationBarHidden:YES animated:YES];
    self.timetable.delegate = self;
	self.timetable.dataSource = self;
	[self.view addSubview:self.timetable];
	[self.paritySelector addTarget:self
							action:@selector(parityUpdated:forEvent:)
				  forControlEvents:UIControlEventValueChanged];

	self.daySelector.numberOfPages = 6;
	self.daySelector.enabled = 1;
	//gestures
	UISwipeGestureRecognizer* leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeL)];
	leftSwipe.numberOfTouchesRequired = 1;
	leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
	[self.view addGestureRecognizer:leftSwipe];
	

	UISwipeGestureRecognizer* rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeR)];
	rightSwipe.numberOfTouchesRequired = 1;
	rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
	[self.view addGestureRecognizer:rightSwipe];

	
   [super viewDidLoad];

	//downloading
	NSString *timetableURLString = [NSString stringWithFormat:@"http://api.ssutt.org:8080/2/department/%@/group/%@", self.selectedDepartment.tag, [self.selectedGroup stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"%@", timetableURLString);
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:timetableURLString]];
	
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
	

		
	[self.timetable reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
		[self.timetable reloadData];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %d bytes of data",[self.responseData length]);
    self.parser = [[TTPParser alloc] init];
    NSError *error;
	self.timetableAccessor = [[TTPTimetableAccessor alloc] init];
	self.timetableAccessor.timetable = [self.parser parseTimetables:self.responseData error:error];
	self.dayLessons = [self.timetableAccessor getLessonsOnDayParity:[NSNumber numberWithInt:self.daySelector.currentPage] parity:[NSNumber numberWithInt:0]];

	self.daynameLabel.text = [self convertNumToDays:[NSNumber numberWithInt:self.daySelector.numberOfPages]];
	[self.timetable reloadData];
}

#pragma mark - Timetable
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.dayLessons.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTPSubjectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LessonCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[TTPSubjectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LessonCell"];
    }
	TTPLesson *lesson = [self.dayLessons objectAtIndex:indexPath.row];

	cell.subjectNameLabel.text = lesson.name;
	cell.subjectTypeLabel.text = lesson.activity;
	cell.beginTimeLabel.text = [self.timetableAccessor getBeginTimeBySequence:lesson.sequence];
	cell.endTimeLabel.text = [self.timetableAccessor getEndTimeBySequence:lesson.sequence];
	
    return cell;
}

#pragma mark - Actions
- (void)handleSwipeL {
	if (self.daySelector.currentPage + 1 >= self.daySelector.numberOfPages) {
		self.daySelector.currentPage = 0;
	}
	else {
		self.daySelector.currentPage = self.daySelector.currentPage + 1;
	}

	self.dayLessons = [self.timetableAccessor getLessonsOnDayParity:[NSNumber numberWithInt: self.daySelector.currentPage] parity:[NSNumber numberWithInt:self.paritySelector.selectedSegmentIndex]];

	self.daynameLabel.text = [self convertNumToDays: [NSNumber numberWithInt:self.daySelector.currentPage]];

	[self.timetable reloadData];
}

- (void)handleSwipeR {
	if (self.daySelector.currentPage - 1 < 0) {
		self.daySelector.currentPage = 5;
	}
	else {
		self.daySelector.currentPage = self.daySelector.currentPage - 1;
	}

	self.dayLessons = [self.timetableAccessor getLessonsOnDayParity:[NSNumber numberWithInt: self.daySelector.currentPage] parity:[NSNumber numberWithInt:self.paritySelector.selectedSegmentIndex]];
	
	self.daynameLabel.text = [self convertNumToDays: [NSNumber numberWithInt:self.daySelector.currentPage]];
	
	[self.timetable reloadData];
	
}

- (void)parityUpdated:(id)sender forEvent:(UIEvent *)event {
	NSLog(@"Parity was updated");
	[self.dayLessons removeAllObjects];
    self.dayLessons = [self.timetableAccessor getLessonsOnDayParity:[NSNumber numberWithInt: self.daySelector.currentPage] parity:[NSNumber numberWithInt:self.paritySelector.selectedSegmentIndex]];

	[self.timetable reloadData];
}

#pragma  mark - Private stuff

- (NSString *)convertNumToDays:(NSNumber *)num {
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale preferredLanguages] objectAtIndex:0]]];

	NSArray *weekdays = [df weekdaySymbols];
	if ([num intValue] +1 >= 7)
		num = [NSNumber numberWithInt:0];
	return [weekdays objectAtIndex:[num intValue] +1];

}

-(void) updateDisplay:(NSString *)str
{
	
	[self.daynameLabel performSelectorOnMainThread : @selector(setText : ) withObject:str waitUntilDone:YES];
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

@end