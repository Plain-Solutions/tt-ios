//
// Created by Vladislav Slepukhin on 04/06/14.
// Copyright (c) 2014 Plain Solution. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TTPSubject : NSObject
@property NSString *name;
@property NSString *activity;
@property NSNumber *parity;
@property NSMutableArray *subgroups;

- (NSString *)description;
@end