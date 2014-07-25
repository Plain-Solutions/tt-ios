//
//  TTPTimetableDataViewController.m
//  Timetables
//
//  Created by Vladislav Slepukhin on 23/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import "TTPTimetableDataViewController.h"
#import "TTPSubjectCell.h"

@interface TTPTimetableDataViewController ()

@end

@implementation TTPTimetableDataViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.table.dataSource = self;
	self.table.delegate = self;
	NSLog(@"Height: %f/%f", self.table.frame.size.height, self.view.bounds.size.height);
	self.table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height - self.table.frame.size.height + 40)];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    if (section == 0)
        return 2.5;
    return 0.5;
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
	TTPSubjectCell *cell;
	if ([subjectsDPT indexOfObject:subj] == 0) {
		cell = [tableView dequeueReusableCellWithIdentifier:@"withTime"];
		if (cell == nil)
				cell = [tableView dequeueReusableCellWithIdentifier:@"withTime"];
	
		cell.timeLabel.text = [self.accessor timeRangeBySequence:sequence];
		
		
		cell.subjectNameLabel.text = [NSString stringWithFormat:@"%@%@",[[subj.name substringToIndex:1] uppercaseString],
									  [subj.name substringFromIndex:1]];
		
		
		cell.subjectTypeLabel.text = NSLocalizedString(subj.activity, nil);
		
		cell.locationLabel.text= [self.accessor locationOnSingleSubgroupCount:subj.subgroups];
		
		cell.activityImg.image= [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", subj.activity]];

		return cell;
	}
	cell = [tableView dequeueReusableCellWithIdentifier:@"noTime"];
	if (cell == nil)
		cell = [tableView dequeueReusableCellWithIdentifier:@"noTime"];
	
	cell.subjectNameLabel.text = [NSString stringWithFormat:@"%@%@",[[subj.name substringToIndex:1] uppercaseString],
								  [subj.name substringFromIndex:1]];
	
	
	cell.subjectTypeLabel.text = NSLocalizedString(subj.activity, nil);
	
	cell.locationLabel.text= [self.accessor locationOnSingleSubgroupCount:subj.subgroups];
	
	cell.activityImg.image= [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", subj.activity]];

	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
		return 100;
    } else {
		return 80;
    }
}

@end
