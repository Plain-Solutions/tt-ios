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

@interface TTPDepMsgViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *departmentMessageView;
@property (strong, nonatomic) NSString *departmentTag;
@end
