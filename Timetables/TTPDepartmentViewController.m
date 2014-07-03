//
//  TTPDepartmentViewController.m
//  Timetables
//
//  Created by Vlad Selpukhin on 29/06/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import "TTPDepartmentViewController.h"
#import "TTPDepartment.h"
#import "TTPParser.h"
#import "TTPGroupViewController.h"

#define ShowNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
#define HideNetworkActivityIndicator() [UIApplication sharedApplication].networkActivityIndicatorVisible = NO

@interface TTPDepartmentViewController ()
@property (nonatomic, strong) TTPParser *parser;
@property (retain) NSIndexPath* lastIndexPath;
@end

@implementation TTPDepartmentViewController

@synthesize nextButton = _nextButton;
@synthesize parser = _parser;
@synthesize lastIndexPath = _lastIndexPath;

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
 
	dispatch_queue_t downloadQueue = dispatch_queue_create("downloader", NULL);
    dispatch_async(downloadQueue, ^{
		NSString *depURL = @"http://api.ssutt.org:8080/1/departments";
		ShowNetworkActivityIndicator();
        // do our long running process here
		NSURLRequest* request = [NSURLRequest requestWithURL: [NSURL URLWithString: depURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
        NSURLResponse* response = nil;
        NSError* error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
		NSLog(@"%d", [data length]);
        // do any UI stuff on the main UI thread
        dispatch_async(dispatch_get_main_queue(), ^{
			self.parser = [[TTPParser alloc] init];
			self.departmentList = [self.parser parseDepartments:data error:error];
			[self.tableView reloadData];
			HideNetworkActivityIndicator();
        });
    });
	
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return self.departmentList.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.lastIndexPath = indexPath;
    self.nextButton.enabled = YES;
    [tableView reloadData];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"groupInitialSelect"]) {
//        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];

        TTPDepartment *dep = [self.departmentList objectAtIndexedSubscript:self.lastIndexPath.row];
        TTPGroupViewController *controller = [segue destinationViewController];
        controller.selectedDepartment = dep;
        
    }
}


@end
