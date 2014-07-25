//
//  TTPTimetableDataViewController.m
//  Timetables
//
//  Created by Vladislav Slepukhin on 23/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import "TTPTimetableDataViewController.h"

@interface TTPTimetableDataViewController ()

@end

@implementation TTPTimetableDataViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.table.dataSource = self;
	self.table.delegate = self;
	
	self.table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height)];
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
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"testful"];
	
	if (cell == nil)
		cell = [tableView dequeueReusableCellWithIdentifier:@"testful"];
	UIView *seperator = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height - 1.0, cell.contentView.frame.size.width, 1)];
	seperator.backgroundColor =  [UIColor colorWithWhite:0.85 alpha:1.000];
	[cell.contentView addSubview:seperator];
	
	NSArray *lsn = [self.accessor lessonsOnDayParitySequence:self.day parity:self.parity sequence:indexPath.section];
	for (id i in lsn)
		NSLog(@"%@", [i description]);
	
	cell.textLabel.text = [NSString stringWithFormat:@"%d", self.day];
	
	return cell;
}
@end
