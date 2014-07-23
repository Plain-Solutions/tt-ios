//
//  TTPSettingsViewController.m
//  Timetables
//
//  Created by Vladislav Slepukhin on 23/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import "TTPSettingsViewController.h"
#import "MVYSideMenuController.h"

@interface TTPSettingsViewController ()

@end

@implementation TTPSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

#pragma mark - Navigation

- (IBAction)menuBtnPressed:(id)sender {
	MVYSideMenuController *sideMenuController = [self sideMenuController];
	if (sideMenuController) {
		[sideMenuController openMenu];
	}
}

@end
