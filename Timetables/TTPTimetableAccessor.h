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

typedef enum __parities {
	EvenSubject,
	OddSubject,
	AllWeekSubject,
} TTPParity;

struct __dayParityEntity {
	NSInteger day;
	TTPParity parity;
};


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
 Fetched timetable copy
*/
@property (nonatomic, strong) NSArray *timetable;

/**
 All the days, which have lessons.
 */
@property (nonatomic, strong) NSMutableArray *availableDays;

/**
 Parity names
 */
@property (nonatomic, strong) NSArray *parities;

- (void)populateAvailableDays;
- (NSString *)beginTimeBySequence:(NSNumber *)sequence;
- (NSString *)endTimeBySequence:(NSNumber *)sequence;
- (NSString *)timeRangeBySequence:(NSNumber *)sequence;
- (struct __dayParityEntity)nextDay:(NSInteger)currentDay;
- (struct __dayParityEntity)previousDay:(NSInteger)currentDay;

- (NSInteger)lessonsCountOnDayParity:(NSInteger)day parity:(NSInteger)parity;
- (NSInteger)lessonsCountOnDayParitySequence:(NSInteger)day parity:(NSInteger)parity sequence:(NSInteger)sequence;
- (NSArray *)availableSequencesOnDayParity:(NSInteger)day parity:(NSInteger)parity;
- (NSArray *)lessonsOnDayParitySequence:(NSInteger)day parity:(NSInteger)parity sequence:(NSInteger)sequence;

- (NSString *)locationOnSingleSubgroupCount:(NSArray *)subgroups;
- (NSString *)convertParityNumToString:(NSNumber *)parity;

@end
