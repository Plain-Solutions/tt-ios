//
//  TTPTimetableDataViewController.m
//  Timetables
//
//  Created by Vladislav Slepukhin on 23/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import "TTPTimetableDataViewController.h"

#define MAGIC_NUMBER 20
#define ROW_HEIGHT MAGIC_NUMBER + [self heightForText:subj.name]
@interface TTPTimetableDataViewController ()
@end

@implementation TTPTimetableDataViewController {
	TTPSharedSettingsController *_settings;
	TTPTimetableAccessor *_accessor;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	_accessor = [TTPTimetableAccessor sharedAccessor];
	self.table.dataSource = self;
	self.table.delegate = self;
	
	// A small gap between navbar and first cell in the table
	[self.table setContentInset:UIEdgeInsetsMake(8,0,0,0)];

	
	// Create table footer to give enough space to scroll and avoid
	// extra scrolling
	self.table.tableFooterView = (IS_IPHONE_5)?Frame(0, 0, ViewWidth, 30):Frame(0, 0, ViewWidth, 100);
	// Pull to refresh
	UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
	[refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
	[self.table addSubview:refreshControl];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(updateParity:)
												 name:@"parityUpdated"
											   object:nil];

}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[[NSNotificationCenter defaultCenter] postNotificationName: @"updateDayLabelCalled" object:[NSNumber numberWithInt:self.day]];
	[[NSNotificationCenter defaultCenter] postNotificationName: @"parityUpdateRequest" object:nil];
	[self.table reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSArray *seqs = [_accessor availableSequencesOnDayParity:self.day
																   parity:self.parity];

	return [_accessor lessonsCountOnDayParitySequence:self.day
															parity:self.parity
														  sequence:[[seqs objectAtIndex:section] integerValue]];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [_accessor lessonsCountOnDayParity:self.day parity:self.parity];
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
	NSArray *seqs = [_accessor availableSequencesOnDayParity:self.day
																   parity:self.parity];
	NSNumber *sequence = [seqs objectAtIndex:indexPath.section];
	
	NSArray *subjectsDPT = [_accessor lessonsOnDayParitySequence:self.day
																	   parity:self.parity
																	 sequence:[sequence integerValue]];
	
	TTPSubjectEntity *subj = [subjectsDPT objectAtIndex:indexPath.row];
	TTPSubjectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lessonCell"];

	if (cell == nil)
				cell = [tableView dequeueReusableCellWithIdentifier:@"lessonCell"];
		
	cell.subjectNameLabel.text = CapitalizedString(subj.name);


	cell.subjectTypeLabel.text =  [CapitalizedString(NSLocalizedString(subj.activity, nil)) stringByAppendingString:@"  "];
	CGSize typeSize = [cell.subjectTypeLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
												REGULAR_FONT, NSFontAttributeName,
												[UIColor whiteColor], NSForegroundColorAttributeName, nil]];

	cell.subjectTypeLabel.textColor = [UIColor whiteColor];
	cell.subjectTypeLabel.textAlignment = NSTextAlignmentCenter;
	cell.subjectTypeLabel.preferredMaxLayoutWidth = typeSize.width + 10;
	cell.subjectTypeLabel.layer.cornerRadius = 5.0;
	cell.subjectTypeLabel.layer.masksToBounds = YES;
	cell.subjectTypeLabel.backgroundColor = [self activityTypeColor:subj.activity];
	[cell.subjectTypeLabel layoutSubviews];

	
	cell.locationLabel.text = [_accessor locationOnSingleSubgroupCount:subj.subgroups];
	
	UIView *activityView = Frame(0, 0, 15, ROW_HEIGHT);
	activityView.backgroundColor = [self activityTypeColor:subj.activity];
	[[cell contentView] addSubview:activityView];
	
	UIView *leftLineView = Frame(0, 0, 1, ROW_HEIGHT);
	[leftLineView setBackgroundColor:[UIColor lightGrayColor]];
	[[cell contentView] addSubview:leftLineView];

	UIView *rightLineView = Frame(ViewWidth -1, 0, 1, ROW_HEIGHT);
	[rightLineView setBackgroundColor:[UIColor lightGrayColor]];
	[[cell contentView] addSubview:rightLineView];

	UIView *bottomLineView = Frame(0, ROW_HEIGHT, ViewWidth, 0.5);
	[bottomLineView setBackgroundColor:[UIColor lightGrayColor]];
	[[cell contentView] addSubview:bottomLineView];
	
	return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
	UIView *view = Frame(0, 0, ViewWidth, 18);
	/* Create custom view to display section header... */
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height)];
	label.font =  [UIFont fontWithName:@"Helvetica-Medium" size:15.0f];
	label.textAlignment = NSTextAlignmentCenter;
	label.backgroundColor = [UIColor clearColor];
	NSArray *seqs = [_accessor availableSequencesOnDayParity:self.day
														  parity:self.parity];
	NSNumber *sequence = [seqs objectAtIndex:section];

	label.text = [_accessor timeRangeBySequence:sequence];;
	label.textColor = [UIColor blackColor];

	[view addSubview:label];
	
	UIView *lineView = Frame(0, 0, ViewWidth, 1);
	lineView.backgroundColor = [UIColor lightGrayColor];
	[view addSubview:lineView];
	
	UIView *leftLineView = Frame(0, 0, 1, 20);
	[leftLineView setBackgroundColor:[UIColor lightGrayColor]];
	[view  addSubview:leftLineView];

	UIView *rightLineView = Frame(ViewWidth -1, 0, 1, 20);
	[rightLineView setBackgroundColor:[UIColor lightGrayColor]];
	[view addSubview:rightLineView];
	
	view.backgroundColor = [UIColor whiteColor];

	return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	TTPSubjectDetailTableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SubjInfo"];
	
	NSArray *seqs = [_accessor availableSequencesOnDayParity:self.day
													  parity:self.parity];
	NSNumber *sequence = [seqs objectAtIndex:indexPath.section];
	
	NSArray *subjectsDPT = [_accessor lessonsOnDayParitySequence:self.day
														  parity:self.parity
														sequence:[sequence integerValue]];
	TTPSubjectEntity *subj = [subjectsDPT objectAtIndex:indexPath.row];
	controller.subject = subj;
	controller.sequence = sequence;
	[self.navigationController pushViewController:controller animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSArray *seqs = [_accessor availableSequencesOnDayParity:self.day
													  parity:self.parity];
	NSNumber *sequence = [seqs objectAtIndex:indexPath.section];
	
	NSArray *subjectsDPT = [_accessor lessonsOnDayParitySequence:self.day
														  parity:self.parity
														sequence:[sequence integerValue]];
	TTPSubjectEntity *subj = [subjectsDPT objectAtIndex:indexPath.row];

	return MAGIC_NUMBER + [self heightForText:subj.name];
}

-(CGFloat)heightForText:(NSString *)text
{
	NSInteger MAX_HEIGHT = 2000;
	UITextView * textView = [[UITextView alloc] initWithFrame: CGRectMake(0, 0, 280, MAX_HEIGHT)];
	textView.text = text;
	textView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:19.0f];
	[textView sizeToFit];
	return textView.frame.size.height;
}




- (UIColor *)activityTypeColor:(NSString *)activity {
	if ([activity isEqualToString:@"lecture"])
		return LectureColor;
	if ([activity isEqualToString:@"practice"])
		return PracticeColor;
	if ([activity isEqualToString:@"laboratory"])
		return LabColor;
	return [UIColor grayColor];
}

#pragma mark - Actions

- (void)refresh:(UIRefreshControl *)refreshControl {
	_settings = [TTPSharedSettingsController sharedController];
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
										  TTPParser *parser = [TTPParser sharedParser];
										  if (response.statusCode != 200) {
											  [self showErrorAlert:data
															 error:error
															   url:timetableURL
														  response:response];
										  }
										  else {
											  //TT ACCESSOR
											  _accessor.timetable = [parser parseTimetables:data
																						  error:error];
											  
											  HideNetworkActivityIndicator();
											  if (_accessor.timetable.count) {
												  [_accessor populateAvailableDays];
												  [self.table reloadData];
											  }
 												[refreshControl endRefreshing];
										  }});});
}


#pragma mark - Notifications

- (void)updateParity:(NSNotification *)notification
{
	if ([notification.name isEqualToString:@"parityUpdated"]) {
		NSInteger parity = [[notification object] integerValue];
		self.parity = parity;
		[self.table reloadData];
	}
}

#pragma mark - Alerts


- (void)showErrorAlert:(NSData *)data error:(NSError *)error url:(NSString *)timetableURL response:(NSHTTPURLResponse *)response
{
	NSString *errorData = [[NSString alloc] init];
	if (data != nil)
		errorData = [[TTPParser sharedParser] parseError:data error:error];
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



@end