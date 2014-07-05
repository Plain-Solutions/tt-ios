//
//  TTPSubjectDetailTableViewController.m
//  Timetables
//
//  Created by Vlad Selpukhin on 04/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import "TTPSubjectDetailTableViewController.h"

@interface TTPSubjectDetailTableViewController ()
@property (nonatomic, strong) NSMutableArray *lessonsOnDPT;
@end

@implementation TTPSubjectDetailTableViewController
@synthesize selectedLesson = _selectedLesson;
@synthesize accessor = _accessor;
@synthesize lessonsOnDPT = _lessonsOnDPT;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.title = self.selectedLesson.name;
   
    self.lessonsOnDPT = [self.accessor getLessonsOnDayParitySequence:self.selectedLesson.day
                                                                  parity:self.selectedLesson.parity
                                                            sequence:self.selectedLesson.sequence];
    for (TTPLesson *l in self.lessonsOnDPT) {
        NSLog(@"%d", l.subgroups.count);
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.lessonsOnDPT.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    TTPLesson *lesson = [self.lessonsOnDPT objectAtIndex:section];
    return 4 + lesson.subgroups.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TTPLesson *lesson = [self.lessonsOnDPT objectAtIndex:indexPath.section];
    //we go to subgroup cells
    if (indexPath.row > 3) {
        TTPSubgroupCell *sgCell = [tableView dequeueReusableCellWithIdentifier:@"subgroupInfo" forIndexPath:indexPath];
        if (sgCell == nil)
            sgCell = [[TTPSubgroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"subgroupInfo"];

        TTPSubgroup *sub = [lesson.subgroups objectAtIndex:indexPath.row-4];
        sgCell.subgroupTeacherName.text = sub.teacher;
        sgCell.subgroupNameLabel.text = sub.subgroupName;
        sgCell.subgroupLocationLabel.text = sub.location;
        return sgCell;
    }
    
    UITableViewCell *defaultCell = [tableView dequeueReusableCellWithIdentifier:@"basicInfo" forIndexPath:indexPath];
    if (defaultCell == nil)
        defaultCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"basicInfo"];

    NSArray *basicInfoCompilation = [NSArray arrayWithObjects:lesson.name,
                                     lesson.activity,
                                     [self.accessor getTimeRangeBySequence:lesson.sequence],
                                     [self.accessor convertParityNumToString:lesson.parity],
                                     nil];
    NSString *defaultCellText =  [[NSString stringWithString:[basicInfoCompilation objectAtIndex:indexPath.row]] capitalizedString];

    [defaultCell.textLabel setText:defaultCellText];
//    TTPSubgroupCell *subgroupCell = [tableView dequeueReusableCellWithIdentifier:@"subgroupInfo" forIndexPath:indexPath];
    
    
    return defaultCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 3) {
        return 100.0;
    }
    else
    {
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
