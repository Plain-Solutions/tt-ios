//
//  TTPTimetableDataViewController.m
//  Timetables
//
//  Created by Vladislav Slepukhin on 23/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import "TTPTimetableDataViewController.h"
#import "TTPSubjectCell.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface TTPTimetableDataViewController ()

@end

@implementation TTPTimetableDataViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.table.dataSource = self;
	self.table.delegate = self;
	self.table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height - self.table.frame.size.height + 40)];


	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(updateParity:)
												 name:@"parityUpdated"
											   object:nil];

}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[[NSNotificationCenter defaultCenter] postNotificationName: @"updateDayLabelCalled" object:[NSNumber numberWithInt:self.day]];
	
	NSMutableArray *__days = [[NSMutableArray alloc] initWithObjects:@0, @0, @0, @0, @0, @0, nil];
	for (int i = 0; i < 6; i++) {
		if ([(NSNumber *)self.accessor.availableDays[i] boolValue] == NO) {
			__days[i] = @0;
		}
		if ([(NSNumber *)self.accessor.availableDays[i] boolValue] == YES) {
			__days[i] = @1;
		}
		if ([(NSNumber *)self.accessor.availableDays[i] boolValue] == YES && i == self.day) {
			__days[i] = @2;
		}
	}	
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.table) {
        if (scrollView.contentOffset.y < 0) {
            scrollView.contentOffset = CGPointZero;
        }
	}
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
	
	UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 1)];
	lineView.backgroundColor = [UIColor lightGrayColor];
	[view addSubview:lineView];
	
	view.backgroundColor = [UIColor whiteColor];
	return view;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60;
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





@end
