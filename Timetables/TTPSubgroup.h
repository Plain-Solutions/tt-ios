//
// Created by Vladislav Slepukhin on 04/06/14.
// Copyright (c) 2014 Plain Solution. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Entity of subgroup.
 A helping entity to store subgroup information in timetable
 This can be empty as well as the whole array. Please check
 */
@interface TTPSubgroup : NSObject

/**
 Subgroup name.
 */
@property NSString *subgroupName;

/**
 Teacher's name.
 */
@property NSString *teacher;

/**
 Place: building + room now together as not implemenet in SSU yet.
 */
@property NSString *location;

- (NSString *)description;
@end