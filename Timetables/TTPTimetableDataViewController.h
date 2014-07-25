//
//  TTPTimetableDataViewController.h
//  Timetables
//
//  Created by Vladislav Slepukhin on 23/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTPTimetableDataViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) id dataObject;
@property (weak, nonatomic) IBOutlet UITableView *table;


@end
