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
 All the days, which have lessons.
 */
@property (nonatomic, strong) NSMutableArray *availableDays;

/**
 First day of the week with lessons.
 */
@property (nonatomic, strong) NSNumber *firstAvailableDay;

/**
 Last day of the week with lessons.
 */
@property (nonatomic, strong) NSNumber *lastAvailableDay;


/**
 Parity names
 */
@property (nonatomic, strong) NSArray *parities;

- (NSString *)getBeginTimeBySequence:(NSNumber *)sequence;
- (NSString *)getEndTimeBySequence:(NSNumber *)sequence;
- (NSString *)getTimeRangeBySequence:(NSNumber *)sequence;
- (NSNumber *)getNextDay:(int)currentDay;
- (NSNumber *)getPreviousDay:(int)currentDay;
- (void)populateAvailableDays;

- (NSMutableArray *)getLessonsOnDayParity:(NSNumber *)day parity:(NSNumber *)parity withRepeats:(BOOL)isRepeated;
- (NSMutableArray *)getLessonsOnDayParitySequence:(NSNumber *)day parity:(NSNumber *)parity sequence:(NSNumber *)sequence;
- (NSString *)getLocationOnSingleSubgroupCount:(NSMutableArray *)subgroups;

- (NSString *)localizeActivities:(NSString *)activity;
- (NSString *)convertParityNumToString:(NSNumber *)parity;
-(id)initWithTimetable:(NSMutableArray *)timetable;
@end
