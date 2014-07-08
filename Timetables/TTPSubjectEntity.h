//
//  TTPSubjectEntity.h
//  Timetables
//
//  Created by Vladislav Slepukhin on 08/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Entity to store subject data according to API v2.
 */
@interface TTPSubjectEntity : NSObject

/**
 The name of the subject
 */
@property (nonatomic, strong) NSString *name;

/**
 Type of activity. See more in TTPTimetableAccessor
 */
@property (nonatomic, strong) NSString *activity;

/**
 Parity: 0 - even, 1 - odd, 2 - both
 */
@property (nonatomic, strong) NSNumber *parity;

/**
 Array of subgroups for subject
 */
@property (nonatomic, strong) NSArray *subgroups;
@end
