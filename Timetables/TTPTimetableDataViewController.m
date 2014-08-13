//
//  TTPTimetableDataViewController.m
//  Timetables
//
//  Created by Vladislav Slepukhin on 23/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import "TTPTimetableDataViewController.h"
#import "TTPParser.h"
#import "TTPGroup.h"
#import "TTPSubjectCell.h"
#import "TTPSubjectDetailTableViewController.h"
#import "ViewControllerDefines.h"

#define CELL_HEIGHT 60
#define IS_IPHONE_5 self.view.bounds.size.height > 480.0
@interface TTPTimetableDataViewController ()

@end

@implementation TTPTimetableDataViewController

- (void)viewDidLoad
{
	self.table.dataSource = self;
	self.table.delegate = self;
	[self.table setContentInset:UIEdgeInsetsMake(8,0,0,0)];
    [super viewDidLoad];
	NSLog(@"%f", self.view.bounds.size.height);
	self.table.tableFooterView = (IS_IPHONE_5)?[[UIView alloc] initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, 30)]:
	[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];


	UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
	[refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
	[self.table addSubview:refreshControl];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(updateParity:)
												 name:@"parityUpdated"
											   object:nil];

}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[[NSNotificationCenter defaultCenter] postNotificationName: @"updateDayLabelCalled" object:[NSNumber numberWithInt:self.day]];

	
//	NSMutableArray *__days = [[NSMutableArray alloc] initWithObjects:@0, @0, @0, @0, @0, @0, nil];
//	for (int i = 0; i < 6; i++) {
//		if ([(NSNumber *)self.accessor.availableDays[i] boolValue] == NO) {
//			__days[i] = @0;
//		}
//		if ([(NSNumber *)self.accessor.availableDays[i] boolValue] == YES) {
//			__days[i] = @1;
//		}
//		if ([(NSNumber *)self.accessor.availableDays[i] boolValue] == YES && i == self.day) {
//			__days[i] = @2;
//		}
//	}	
	[[NSNotificationCenter defaultCenter] postNotificationName: @"parityUpdateRequest" object:nil];

	
	
}

- (void)updateParity:(NSNotification *)notification
{
	if ([notification.name isEqualToString:@"parityUpdated"]) {
		NSInteger parity = [[notification object] integerValue];
		self.parity = parity;
		[self.table reloadData];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSArray *seqs = [self.accessor availableSequencesOnDayParity:self.day
																   parity:self.parity];
	
	return [self.accessor lessonsCountOnDayParitySequence:self.day
															parity:self.parity
														  sequence:[[seqs objectAtIndex:section] integerValue]];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [self.accessor lessonsCountOnDayParity:self.day parity:self.parity];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
	return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSArray *seqs = [self.accessor availableSequencesOnDayParity:self.day
																   parity:self.parity];
	NSNumber *sequence = [seqs objectAtIndex:indexPath.section];
	
	NSArray *subjectsDPT = [self.accessor lessonsOnDayParitySequence:self.day
																	   parity:self.parity
																	 sequence:[sequence integerValue]];
	
	TTPSubjectEntity *subj = [subjectsDPT objectAtIndex:indexPath.row];
	TTPSubjectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lessonCell"];
	
	if (cell == nil)
				cell = [tableView dequeueReusableCellWithIdentifier:@"lessonCell"];
		
	cell.subjectNameLabel.text = [NSString stringWithFormat:@"%@%@",[[subj.name substringToIndex:1] uppercaseString],
								  [subj.name substringFromIndex:1]];
	
	NSString *__actLocal = NSLocalizedString(subj.activity, nil);
	cell.subjectTypeLabel.text = [NSString stringWithFormat:@"%@%@", [[__actLocal substringToIndex:1] capitalizedString], [__actLocal substringFromIndex:1]];
	cell.locationLabel.text = [self.accessor locationOnSingleSubgroupCount:subj.subgroups];
	
	cell.activityView.backgroundColor = [self activityTypeColor:subj.activity];

	UIView *leftLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 60)];
	[leftLineView setBackgroundColor:[UIColor lightGrayColor]];
	[[cell contentView] addSubview:leftLineView];

	UIView *rightLineView = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 1, 0, 1, 60)];
	[rightLineView setBackgroundColor:[UIColor lightGrayColor]];
	[[cell contentView] addSubview:rightLineView];

	UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, self.view.bounds.size.width, 0.5)];
	[bottomLineView setBackgroundColor:[UIColor lightGrayColor]];
	[[cell contentView] addSubview:bottomLineView];

	
	return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
	/* Create custom view to display section header... */
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height)];
	label.font =  [UIFont fontWithName:@"Helvetica-Medium" size:15.0f];
	label.textAlignment = NSTextAlignmentCenter;
	label.backgroundColor = [UIColor clearColor];
	NSArray *seqs = [self.accessor availableSequencesOnDayParity:self.day
														  parity:self.parity];
	NSNumber *sequence = [seqs objectAtIndex:section];

	label.text = [self.accessor timeRangeBySequence:sequence];;
	label.textColor = [UIColor blackColor];

	[view addSubview:label];
	
	UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
	lineView.backgroundColor = [UIColor lightGrayColor];
	[view addSubview:lineView];
	
	UIView *leftLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 20)];
	[leftLineView setBackgroundColor:[UIColor lightGrayColor]];
	[view  addSubview:leftLineView];

	UIView *rightLineView = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 1, 0, 1, 20)];
	[rightLineView setBackgroundColor:[UIColor lightGrayColor]];
	[view addSubview:rightLineView];


	
	view.backgroundColor = [UIColor whiteColor];
	return view;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return CELL_HEIGHT;
}

- (UIColor *)activityTypeColor:(NSString *)activity {
	if ([activity isEqualToString:@"lecture"])
		return RGB(255, 94, 58);
	if ([activity isEqualToString:@"practice"])
		return RGB(76, 217,100);
	if ([activity isEqualToString:@"laboratory"])
		return RGB(90, 200,250);
	return [UIColor grayColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	TTPSubjectDetailTableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SubjInfo"];

	NSArray *seqs = [self.accessor availableSequencesOnDayParity:self.day
														  parity:self.parity];
	NSNumber *sequence = [seqs objectAtIndex:indexPath.section];
	
	NSArray *subjectsDPT = [self.accessor lessonsOnDayParitySequence:self.day
															  parity:self.parity
															sequence:[sequence integerValue]];
	TTPSubjectEntity *subj = [subjectsDPT objectAtIndex:indexPath.row];
	controller.subject = subj;
	controller.sequence = sequence;
	[self.navigationController pushViewController:controller animated:YES];
}



- (void)refresh:(UIRefreshControl *)refreshControl {
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
											  self.accessor.timetable = [parser parseTimetables:data
																						  error:error];
											  
											  HideNetworkActivityIndicator();
											  if (self.accessor.timetable.count) {
												  [self.accessor populateAvailableDays];
												  [self.table reloadData];
											  }
 												[refreshControl endRefreshing];
										  }});});
}

@end
