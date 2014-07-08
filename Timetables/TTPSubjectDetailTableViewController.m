//
//  TTPSubjectDetailTableViewController.m
//  Timetables
//
//  Created by Vlad Selpukhin on 04/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import "TTPSubjectDetailTableViewController.h"

@interface TTPSubjectDetailTableViewController ()
@property (nonatomic, strong) TTPTimetableAccessor *accessor;
@end

@implementation TTPSubjectDetailTableViewController

- (id)initWithStyle:(UITableViewStyle)style;
{
    if (self = [super initWithStyle:style]) {
    }
    return self;
}

- (void)viewDidLoad;
{
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.title = self.subject.name;
	self.accessor = [[TTPTimetableAccessor alloc] init];
}

- (void)didReceiveMemoryWarning;
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 4 + self.subject.subgroups.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    // we go to subgroup cells
    if (indexPath.row > 3) {
        TTPSubgroupCell *sgCell = [tableView dequeueReusableCellWithIdentifier:@"subgroupInfo" forIndexPath:indexPath];
        if (sgCell == nil)
            sgCell = [[TTPSubgroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"subgroupInfo"];

        TTPSubgroup *sub = [self.subject.subgroups objectAtIndex:indexPath.row-4];
        sgCell.subgroupTeacherName.text = sub.teacher;
        sgCell.subgroupLocationLabel.text = sub.location;
		sgCell.subgroupNameLabel.text = sub.subgroupName;


        return sgCell;
    }
    // else we go for default (basic) cell
    UITableViewCell *defaultCell = [tableView dequeueReusableCellWithIdentifier:@"basicInfo" forIndexPath:indexPath];
    if (defaultCell == nil)
        defaultCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"basicInfo"];

    NSArray *basicInfoCompilation = [NSArray arrayWithObjects:self.subject.name,
                                     self.subject.activity,
                                     [self.accessor timeRangeBySequence:[NSNumber numberWithInt:self.sequence]],
                                     [self.accessor convertParityNumToString:self.subject.parity],
                                     nil];
    NSString *defaultCellText =  [[NSString stringWithString:[basicInfoCompilation objectAtIndex:indexPath.row]] capitalizedString];

    [defaultCell.textLabel setText:defaultCellText];
    defaultCell.textLabel.numberOfLines = 0;

    return defaultCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{

    if (indexPath.row > 3) {
		TTPSubgroup *sub = [self.subject.subgroups objectAtIndex:indexPath.row - 4];
		if (sub.subgroupName.length)
			return 100.0;
		return 60.0;
    }
    else
    {
		if (self.subject.name.length > 23)
			return 50.0;
		return 35.0;
    }
}

@end
