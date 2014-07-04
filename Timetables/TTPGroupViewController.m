//
//  TTPGroupViewController.m
//  Timetables
//
//  Created by Vlad Selpukhin on 29/06/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import "TTPGroupViewController.h"

@interface TTPGroupViewController ()
@property (nonatomic, strong) TTPParser *parser;
@property (retain) NSIndexPath *lastIndexPath;
@end

@implementation TTPGroupViewController
@synthesize selectedDepartment = _selectedDepartment;
@synthesize groupList = _groupList;

@synthesize nextButton = _nextButton;
@synthesize parser = _parser;
@synthesize lastIndexPath = _lastIndexPath;


- (id)initWithStyle:(UITableViewStyle)style;
{
    self = [super initWithStyle:style];
    return self;
}

- (void)viewDidLoad;
{
    [super viewDidLoad];
    self.title = self.selectedDepartment.name;
	
	dispatch_queue_t downloadQueue = dispatch_queue_create("downloader", NULL);
    dispatch_async(downloadQueue, ^{
		NSString *groupURL = [NSString stringWithFormat:@"http://api.ssutt.org:8080/1/department/%@/groups?filled=1",
							  self.selectedDepartment.tag];
		ShowNetworkActivityIndicator();
        // do our long running process here
		NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString: groupURL]
												 cachePolicy:NSURLRequestUseProtocolCachePolicy
											 timeoutInterval:60];
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

        // do any UI stuff on the main UI thread
        dispatch_async(dispatch_get_main_queue(), ^{
			self.parser = [[TTPParser alloc] init];
			self.groupList = [self.parser parseGroups:data error:error];
			[self.tableView reloadData];
			HideNetworkActivityIndicator();
        });
    });

}

- (void)viewWillAppear:(BOOL)animated;
{
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO];
	[self.tableView reloadData];
}

- (void)didReceiveMemoryWarning;
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.groupList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GroupCell"];
    }
	
    cell.textLabel.text = [self.groupList objectAtIndexedSubscript:indexPath.row];
    if ([indexPath compare:self.lastIndexPath] == NSOrderedSame)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    self.lastIndexPath = indexPath;
    self.nextButton.enabled = YES;
    [tableView reloadData];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;
{
	if ([segue.identifier isEqualToString:@"showTimetableView"]) {
		NSString *group = [self.groupList objectAtIndex:self.lastIndexPath.row];
		
		TTPTimetableViewController *controller = [segue destinationViewController];
		controller.selectedDepartment = self.selectedDepartment;
		controller.selectedGroup = group;
	}
}

@end
