//
//  TTPDepartmentViewController.m
//  Timetables
//
//  Created by Vlad Selpukhin on 29/06/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import "TTPDepartmentViewController.h"

@interface TTPDepartmentViewController ()
@property (nonatomic, strong) TTPParser *parser;
@property (retain) NSIndexPath* lastIndexPath;
@end

@implementation TTPDepartmentViewController

@synthesize nextButton = _nextButton;
@synthesize parser = _parser;
@synthesize lastIndexPath = _lastIndexPath;

- (id)initWithStyle:(UITableViewStyle)style;
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad;
{
    [super viewDidLoad];
 
	dispatch_queue_t downloadQueue = dispatch_queue_create("downloader", NULL);
    dispatch_async(downloadQueue, ^{
		NSString *depURL = @"http://api.ssutt.org:8080/1/departments";
		ShowNetworkActivityIndicator();
        // do our long running process here
		NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: depURL]
												 cachePolicy:NSURLRequestUseProtocolCachePolicy
											 timeoutInterval:60];
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request
											 returningResponse:&response
														 error:&error];
        // do any UI stuff on the main UI thread
        dispatch_async(dispatch_get_main_queue(), ^{
			self.parser = [[TTPParser alloc] init];
			self.departmentList = [self.parser parseDepartments:data error:error];
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
   return self.departmentList.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DepCell"];
    
    TTPDepartment *dep = [self.departmentList objectAtIndex:indexPath.row];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DepCell"];
    }
    cell.textLabel.text = [self.parser prettifyDepartmentNames:dep.name];
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
    if ([segue.identifier isEqualToString:@"groupInitialSelect"]) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.lastIndexPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
        

        TTPDepartment *dep = [self.departmentList objectAtIndexedSubscript:self.lastIndexPath.row];
        TTPGroupViewController *controller = [segue destinationViewController];
        controller.selectedDepartment = dep;
        self.lastIndexPath = nil;
    }
}


@end
