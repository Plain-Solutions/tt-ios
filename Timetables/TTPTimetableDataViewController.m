//
//  TTPTimetableDataViewController.m
//  Timetables
//
//  Created by Vladislav Slepukhin on 23/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import "TTPTimetableDataViewController.h"
#import "MVYSideMenuController.h"

#define MAGIC_NUMBER 20
#define RowHeightFromHash(subject) [_heights[[NSString stringWithFormat:@"%ld", (unsigned long)subject.hash]] floatValue]
@interface TTPTimetableDataViewController ()
@end

@implementation TTPTimetableDataViewController {
	TTPSharedSettingsController *_settings;
	TTPTimetableAccessor *_accessor;

	NSNumber *_selectedSequence;
	NSDictionary *_heights;
	
	BOOL _notFirstTimeLoadFromCache;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	_accessor = [TTPTimetableAccessor sharedAccessor];
	if (self.isLoadedFromCache) {
		dispatch_queue_t mvlQ = dispatch_queue_create("mainviewload", NULL);
		dispatch_async(mvlQ, ^{
			[NSThread sleepForTimeInterval:0.1];
			dispatch_async(dispatch_get_main_queue(),^ {
				[[NSNotificationCenter defaultCenter] postNotificationName: @"updateDayLabelCalled" object:[NSNumber numberWithInt:self.day]];

			});});
	}

	self.table.dataSource = self;
	self.table.delegate = self;
	self.table.separatorStyle = UITableViewCellSeparatorStyleNone;

	// A small gap between navbar and first cell in the table
	[self.table setContentInset:UIEdgeInsetsMake(8,0,0,0)];

	// Create table footer to give enough space to scroll and avoid
	// extra scrolling
	self.table.tableFooterView = (IS_IPHONE_5)?Frame(0, 0, ViewWidth, 30):Frame(0, 0, ViewWidth, 100);
	// Pull to refresh
	self.refreshControl = [[UIRefreshControl alloc] init];
	[self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
	[self.table addSubview:self.refreshControl];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(updateParity:)
												 name:@"parityUpdated"
											   object:nil];

}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[[NSNotificationCenter defaultCenter] postNotificationName: @"parityUpdateRequest" object:nil];
	NSMutableDictionary *__heights = [[NSMutableDictionary alloc] init];
	for (TTPDaySequenceEntity *e in _accessor.timetable)
		for (TTPSubjectEntity *_e in e.subjects)
			[__heights setObject:[NSNumber numberWithFloat:MAGIC_NUMBER + [self heightForText:_e.name]]
						  forKey:[NSString stringWithFormat:@"%d", _e.hash]];
	_heights = [NSDictionary dictionaryWithDictionary:__heights];

	[self.table reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[[NSNotificationCenter defaultCenter] postNotificationName: @"updateDayLabelCalled" object:[NSNumber numberWithInt:self.day]];
	if (self.isLoadedFromCache)
		[self refresh:nil];
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
	TTPSubjectEntity *subj = [self subjectForIndexPath:indexPath];
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
	
	[[cell viewWithTag:1337] removeFromSuperview];
	UIView *activityView = Frame(0, 0, 15, RowHeightFromHash(subj));
	activityView.backgroundColor = [self activityTypeColor:subj.activity];
	activityView.tag = 1337;
	[[cell contentView] addSubview:activityView];
	
	[[cell viewWithTag:1488] removeFromSuperview];
	UIView *rect = Frame(0, 0, ViewWidth, RowHeightFromHash(subj));
	rect.tag = 1488;
	rect.backgroundColor = [UIColor clearColor];
	rect.layer.borderColor = [UIColor grayColor].CGColor;
	rect.layer.borderWidth = 1.0f;
	[[cell contentView] addSubview:rect];
	
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

	label.text = [_accessor timeRangeBySequence:sequence];
	label.textColor = [UIColor blackColor];

	[view addSubview:label];
	
	UIView *rect = Frame(0, 0, ViewWidth, 20);
	rect.backgroundColor = [UIColor clearColor];
	rect.layer.borderColor = [UIColor grayColor].CGColor;
	rect.layer.borderWidth = 0.5f;
	[view addSubview:rect];
	
	view.backgroundColor = [UIColor whiteColor];

	return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	TTPSubjectEntity *subj = [self subjectForIndexPath:indexPath];
	_selectedSequence = [self sequenceForIndexPath:indexPath];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	[self showDetailsAlert:subj];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [_heights[[NSString stringWithFormat:@"%ld", (unsigned long)[self subjectForIndexPath:indexPath].hash]] floatValue];
}


#pragma mark - Private methods

- (NSNumber *)sequenceForIndexPath:(NSIndexPath *)indexPath
{
	NSArray *seqs = [_accessor availableSequencesOnDayParity:self.day
													  parity:self.parity];

	return [seqs objectAtIndex:indexPath.section];
}

- (TTPSubjectEntity *)subjectForIndexPath:(NSIndexPath *)indexPath
{
	NSNumber *sequence = [self sequenceForIndexPath:indexPath];
	NSArray *subjectsDPT = [_accessor lessonsOnDayParitySequence:self.day
														  parity:self.parity
														sequence:[sequence integerValue]];

	return [subjectsDPT objectAtIndex:indexPath.row];
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
											  if (!_notFirstTimeLoadFromCache)
												  _notFirstTimeLoadFromCache = YES;
											  else
												  [self showErrorAlert:data
															 error:error
															   url:timetableURL
														  response:response];
											  
										  }
										  else {
											  //TT ACCESSOR
											  _accessor.timetable = [parser parseTimetables:data
																						  error:error];
											  NSMutableDictionary *__heights = [[NSMutableDictionary alloc] init];
											  for (TTPDaySequenceEntity *e in _accessor.timetable)
												  for (TTPSubjectEntity *_e in e.subjects)
													  [__heights setObject:[NSNumber numberWithFloat:MAGIC_NUMBER + [self heightForText:_e.name]]
																	forKey:[NSString stringWithFormat:@"%d", _e.hash]];
											  _heights = [NSDictionary dictionaryWithDictionary:__heights];
											  HideNetworkActivityIndicator();
											  if (_accessor.timetable.count) {
												  [_accessor populateAvailableDays];
												  [self.table reloadData];
											  }
 												
										  }
									  [refreshControl endRefreshing];
									  });});
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

- (void)showDetailsAlert:(TTPSubjectEntity *)subject
{
	
	NSString *title = NSLocalizedString(@"Details", nil);
	NSString *content = [NSString stringWithFormat:NSLocalizedString(@"Name: %@\nType: %@\nTime: %@\nParity: %@\n\n", nil),
						 CapitalizedString(subject.name),
						 CapitalizedString(NSLocalizedString(subject.activity, nil)), [_accessor timeRangeBySequence:_selectedSequence],
						 CapitalizedString([_accessor convertParityNumToString:subject.parity])];

	NSString *subgroupContent = @"";
	for (TTPSubgroup *e in subject.subgroups) {
		if (subject.subgroups.count > 1) {
			subgroupContent = NSLocalizedString(@"Subgroup:\n", nil);
		if (e.subgroupName.length)
			subgroupContent = [NSString stringWithFormat:@"%@\n",CapitalizedString(e.subgroupName)];
		}
		if (e.teacher.length)
			subgroupContent = [subgroupContent stringByAppendingString:[NSString stringWithFormat:NSLocalizedString(@"Teacher: %@\n", nil), e.teacher]];
		if (e.location.length)
			subgroupContent = [subgroupContent stringByAppendingString:[NSString stringWithFormat:NSLocalizedString(@"Location: %@\n\n", nil), e.location]];
		content = [content stringByAppendingString:subgroupContent];
	}
	
	content = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
													message:content
												   delegate:nil
										  cancelButtonTitle:NSLocalizedString(@"Dismiss", nil)
										  otherButtonTitles:nil];
	[alert show];
}

@end