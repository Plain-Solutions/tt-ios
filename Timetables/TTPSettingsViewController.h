//
//  TTPSettingsViewController.h
//  Timetables
//
//  Created by Vladislav Slepukhin on 23/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface TTPSettingsViewController : UITableViewController <UIAlertViewDelegate, MBProgressHUDDelegate>
- (IBAction)menuBtnPressed:(id)sender;

@end
