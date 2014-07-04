//
//  TTPTimetableAccessor.h
//  Timetables
//
//  Created by Vladislav Slepukhin on 02/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTPSubgroup.h"
#import "TTPLesson.h"

/**
 Some sort of library with useful methods to access to data in the timetable.
 It also holds a copy of fetched timetable.
 */
@interface TTPTimetableAccessor : NSObject

/**
 Set of pre-defined lesson beginning times.
 */
@property (nonatomic, strong) NSArray *lessonBeginTimes;

/**
 Set of pre-defined lesson ending times.
 */
@property (nonatomic, strong) NSArray *lessonEndTimes;

/**
 Set of possible activities for localization.
 */
@property (nonatomic, strong) NSArray *availableActivities;

/**
 Fetched timetable copy
*/
@property (nonatomic, strong) NSMutableArray *timetable;

/**
 All the days, which have lessons
 */
@property (nonatomic, strong) NSMutableArray *availableDays;

- (NSString *)getBeginTimeBySequence:(NSNumber *)sequence;
- (NSString *)getEndTimeBySequence:(NSNumber *)sequence;
- (NSMutableArray *)getLessonsOnDayParity:(NSNumber *)day parity:(NSNumber *)parity withRepeats:(BOOL)isRepeated;
- (NSNumber *)getFirstNotEmptyDay;
- (void)populateAvailableDays;

- (NSString *)localizeActivities:(NSString *)activity;

-(id)initWithTimetable:(NSMutableArray *)timetable;
@end
