//
// Created by Vladislav Slepukhin on 04/06/14.
// Copyright (c) 2014 Plain Solution. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Entity of lesson.
 Contains all the information about subject on a day,sequence and time.
 Array of them is the deserialised data from api.ssutt.org
 */
@interface TTPLesson : NSObject

/**
 The day from 0 to 5.
 */
@property NSNumber *day;

/**
 The sequence (order) from 1 to 8.
 */
@property NSNumber *sequence;

/**
 Parity: 0 - even, 1 - odd, 2 - both.
 */
@property NSNumber *parity;

/**
 Subject name.
 */
@property NSString *name;

/**
 Activity type: lecture, practice or lab.
 */
@property NSString *activity;

/**
 Available subgroups. Can be empty. Refer TTPSubgroup for more information.
 */
@property NSMutableArray *subgroups;

+ (id)lessonWithLesson:(TTPLesson *)lesson;
- (id)initWithLesson:(TTPLesson *)lesson;
- (id)copy;
@end