//
// Created by Vladislav Slepukhin on 04/06/14.
// Copyright (c) 2014 Plain Solution. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TTPLesson : NSObject
@property NSNumber *day;
@property NSNumber *sequence;
@property NSMutableArray *subjects;

- (NSString *)description;

@end