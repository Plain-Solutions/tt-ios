//
//  TTPSubjectDetailViewController.m
//  Timetables
//
//  Created by Vladislav Slepukhin on 04/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import "TTPSubjectDetailViewController.h"

@interface TTPSubjectDetailViewController ()

@end

@implementation TTPSubjectDetailViewController
@synthesize selectedLesson = _selectedLesson;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = self.selectedLesson.name;
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated;
{
	[super viewWillAppear:animated];
	[self.navigationController setNavigationBarHidden:NO];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
