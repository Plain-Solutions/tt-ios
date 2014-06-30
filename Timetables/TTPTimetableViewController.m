//
//  TTPTimetableViewController.m
//  Timetables
//
//  Created by Vladislav Slepukhin on 30/06/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import "TTPTimetableViewController.h"
#import "TTPParser.h"
@interface TTPTimetableViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) TTPParser *parser;

@end

@implementation TTPTimetableViewController

@synthesize selectedDepartment = _selectedDepartment;
@synthesize selectedGroup = _selectedGroup;
@synthesize timetableData = _timetableData;

@synthesize responseData = _responseData;
@synthesize parser = _parser;

@synthesize paritySelector = _paritySelector;
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
	[[self navigationController] setNavigationBarHidden:YES animated:YES];
	NSLog(@"Showing in View: %@/%@", self.selectedDepartment.tag, self.selectedGroup);
	
	self.responseData = [NSMutableData data];
    self.timetable.delegate = self;
	self.timetable.dataSource = self;
	[self.view addSubview:self.timetable];
	
    NSString *timetableURLString = [NSString stringWithFormat:@"http://api.ssutt.org:8080/1/department/%@/group/%@", self.selectedDepartment.tag, [self.selectedGroup stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
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
	self.timetableData = [self.parser parseTimetables:self.responseData error:error];
	[self.timetable reloadData];
}

#pragma mark - Timetable
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.timetableData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LessonCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LessonCell"];
    }
	TTPLesson *lesson = [self.timetableData objectAtIndex:indexPath.row];

	cell.textLabel.text = lesson.name;
    return cell;
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
