//
//  TTPSubjectEntity.h
//  Timetables
//
//  Created by Vladislav Slepukhin on 08/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTPSubjectEntity : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *activity;
@property (nonatomic, strong) NSNumber *parity;
@property (nonatomic, strong) NSArray *subgroups;
@end
