//
//  TTPDepMsgViewController.h
//  Timetables
//
//  Created by Vladislav Slepukhin on 08/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTPParser.h"
#import "ViewControllerDefines.h"

/**
 Viewing Dean's office info
 */
@interface TTPDepMsgViewController : UIViewController

/**
 Subview to display parsed and formatted data.
 */
@property (weak, nonatomic) IBOutlet UITextView *departmentMessageView;
- (IBAction)menuBtnPressed:(id)sender;


/**
 Tag to navigate through API
 */
@property (strong, nonatomic) NSString *departmentTag;
@end
