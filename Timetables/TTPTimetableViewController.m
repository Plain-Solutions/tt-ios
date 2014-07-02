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
    [super viewDidLoad];
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
	
	//gestures
	UISwipeGestureRecognizer* leftSwipe;
	
	leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeL)];
	leftSwipe.numberOfTouchesRequired = 1;
	leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
	[self.view addGestureRecognizer:leftSwipe];

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
	TTPLesson *dayLesson = [TTPLesson lessonWithLesson:[self.dayLessons objectAtIndex:0]];
	self.daynameLabel.text = [self convertNumToDays:dayLesson.day];
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
	self.daySelector.currentPage++;
	[self.dayLessons removeAllObjects];
	self.dayLessons = [self.timetableAccessor getLessonsOnDayParity:[NSNumber numberWithInt: self.daySelector.currentPage] parity:[NSNumber numberWithInt:self.paritySelector.selectedSegmentIndex]];
	[self.timetable reloadData];
}

- (void)handleSwipeR {
	
}

- (void)parityUpdated:(id)sender forEvent:(UIEvent *)event {
	NSLog(@"Parity was updated");
	[self.dayLessons removeAllObjects];
    self.dayLessons = [self.timetableAccessor getLessonsOnDayParity:[NSNumber numberWithInt: self.daySelector.currentPage] parity:[NSNumber numberWithInt:self.paritySelector.selectedSegmentIndex]];
	[self.timetable reloadData];
}

#pragma  mark - Private stuff

- (NSString *)convertNumToDays:(NSNumber *)num {
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateFormatter *myFormatter = [[NSDateFormatter alloc] init];
	NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
	
	[dateComponents setWeekday: [num intValue]];
	
	NSDate *tempDate = [gregorian dateFromComponents:dateComponents];
	[myFormatter setDateFormat:@"EEEE"]; // day, like "Saturday"
	
	return [myFormatter stringFromDate:tempDate];
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
