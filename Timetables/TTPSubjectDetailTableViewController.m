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
@synthesize subject =_subject;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.title = self.subject.name;
	self.accessor = [[TTPTimetableAccessor alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4 + self.subject.subgroups.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //we go to subgroup cells
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row > 3) {
		TTPSubgroup *sub = [self.subject.subgroups objectAtIndex:indexPath.row-4];
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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
