//
//  TTPTimetableAccessor.h
//  Timetables
//
//  Created by Vladislav Slepukhin on 02/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTPSubgroup.h"
#import "TTPSubjectEntity.h"
#import "TTPDaySequenceEntity.h"

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
@property (nonatomic, strong) NSArray *timetable;

/**
 All the days, which have lessons.
 */
@property (nonatomic, strong) NSArray *availableDays;

/**
 First day of the week with lessons.
 */
@property (nonatomic, assign) NSInteger firstAvailableDay;

/**
 Last day of the week with lessons.
 */
@property (nonatomic, assign) NSInteger lastAvailableDay;

/**
 Parity names
 */
@property (nonatomic, strong) NSArray *parities;

- (NSString *)beginTimeBySequence:(NSNumber *)sequence;
- (NSString *)endTimeBySequence:(NSNumber *)sequence;
- (NSString *)timeRangeBySequence:(NSNumber *)sequence;
- (NSInteger)nextDay:(NSInteger)currentDay;
- (NSInteger)previousDay:(NSInteger)currentDay;
- (void)populateAvailableDays;

- (NSInteger) lessonsCountOnDayParity:(NSInteger)day parity:(NSInteger)parity;
- (NSInteger) lessonsCountOnDayParitySequence:(NSInteger)day parity:(NSInteger)parity sequence:(NSInteger)sequence;
- (NSArray *) availableSequencesOnDayParity:(NSInteger)day parity:(NSInteger)parity;

- (NSArray *)lessonsOnDayParitySequence:(NSInteger)day parity:(NSInteger)parity sequence:(NSInteger)sequence;

- (NSString *)locationOnSingleSubgroupCount:(NSArray *)subgroups;
- (NSString *)localizeActivities:(NSString *)activity;
- (NSString *)convertParityNumToString:(NSNumber *)parity;
-(id)initWithTimetable:(NSMutableArray *)timetable;
@end
