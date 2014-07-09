//
//  TTPTimetableAccessor.m
//  Timetables
//
//  Used to return some data with simplier methods
//
//  Created by Vladislav Slepukhin on 02/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import "TTPTimetableAccessor.h"
@implementation TTPTimetableAccessor

@synthesize lessonBeginTimes = _lessonBeginTimes;
@synthesize lessonEndTimes = _lessonEndTimes;
@synthesize timetable = _timetable;
@synthesize availableDays = _availableDays;
@synthesize firstAvailableDay = _firstAvailableDay;
@synthesize lastAvailableDay = _lastAvailableDay;
@synthesize parities = _parities;

- (id)init;
{
	self = [super init];
	[self initSets];
	return self;
}

- (void)initSets;
{
	self.lessonBeginTimes = [NSArray arrayWithObjects:@"08:20", @"10:00", @"12:05",
							 @"13:50", @"15:35", @"17:20", @"18:45", @"20:10", nil];
	
	self.lessonEndTimes = [NSArray arrayWithObjects:@"09:50", @"11:35", @"13:40",
						   @"15:25", @"17:10", @"18:40", @"20:05", @"21:30", nil];
    
    self.parities = [NSArray arrayWithObjects:@"even", @"odd", @"even&odd", nil];
}

- (void)populateAvailableDays;
{
	self.firstAvailableDay = [((TTPDaySequenceEntity *)[self.timetable firstObject]).day integerValue];
	self.lastAvailableDay = [((TTPDaySequenceEntity *)[self.timetable lastObject]).day integerValue];
	
	NSMutableSet *setOfAvailDays = [[NSMutableSet alloc] init];
	
	for (TTPDaySequenceEntity *e in self.timetable) {
		[setOfAvailDays addObject:e.day];
	}
	self.availableDays= [[NSArray alloc] initWithArray:[[setOfAvailDays allObjects]
														sortedArrayUsingSelector:@selector(compare:)]];
}

#pragma mark - Timey-wimey

- (NSString *)beginTimeBySequence:(NSNumber *)sequence;
{
	return [self.lessonBeginTimes objectAtIndex: [[NSNumber numberWithInt:[sequence intValue] - 1] intValue]];
}

- (NSString *)endTimeBySequence:(NSNumber *)sequence;
{
	return [self.lessonEndTimes objectAtIndex: [[NSNumber numberWithInt:[sequence intValue] - 1] intValue]];
}
- (NSString *)timeRangeBySequence:(NSNumber *)sequence;
{
    // will be formated as 00:00 - 00:00
    return [NSString stringWithFormat:@"%@ – %@",
			[self beginTimeBySequence:sequence], [self endTimeBySequence:sequence]];
}


- (NSInteger)nextDay:(NSInteger)currentDay;
{
	NSInteger nextIndex = [self.availableDays indexOfObject:[NSNumber numberWithInt:currentDay]]+1;
	if (nextIndex >= self.availableDays.count) {
		return self.firstAvailableDay;
	}
	return [[self.availableDays objectAtIndex:nextIndex] integerValue];
}

- (NSInteger)previousDay:(int)currentDay;
{
	NSInteger prevIndex = [self.availableDays indexOfObject:[NSNumber numberWithInt:currentDay]]-1;
	if (prevIndex < 0) {
		return self.lastAvailableDay;
	}
	return [[self.availableDays objectAtIndex:prevIndex] integerValue];
}

#pragma mark - Getting timetables and stuff

- (NSInteger)lessonsCountOnDayParity:(NSInteger)day parity:(NSInteger)parity;
{
	NSInteger count = 0;

	for (TTPDaySequenceEntity *e  in self.timetable) {
		BOOL addDPT = NO;
		if ([e.day integerValue] == day) {
			for (TTPSubjectEntity *subj in e.subjects) {
				if ([subj.parity integerValue] == parity || [subj.parity integerValue] == 2) {
					addDPT = YES;
					break;
				}
			}
			if (addDPT)
				count++;
		}
    }
	return count;
}
- (NSInteger)lessonsCountOnDayParitySequence:(NSInteger)day parity:(NSInteger)parity sequence:(NSInteger)sequence;
{
	NSInteger count = 0;

	for (TTPDaySequenceEntity *e  in self.timetable) {
		if ([e.day integerValue] == day && [e.sequence integerValue] == sequence) {
			for (TTPSubjectEntity *subj in e.subjects) {
				if ([subj.parity integerValue] == parity || [subj.parity integerValue] == 2)
					count++;
			}
		}
	}
	return count;
}

- (NSArray *)availableSequencesOnDayParity:(NSInteger)day parity:(NSInteger)parity;
{
	NSMutableSet *result = [[NSMutableSet alloc] init];
	for (TTPDaySequenceEntity *e in self.timetable) {
		if ([e.day integerValue] == day) {
			for (TTPSubjectEntity *subj in e.subjects) {
				if ([subj.parity integerValue] == parity || [subj.parity integerValue] == 2)
					[result addObject:e.sequence];
			}
		}
	}
	
	return [[NSArray alloc] initWithArray:[[result allObjects] sortedArrayUsingSelector:@selector(compare:)]];
}

- (NSArray *)lessonsOnDayParitySequence:(NSInteger)day parity:(NSInteger)parity sequence:(NSInteger)sequence;
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
	for (TTPDaySequenceEntity *e  in self.timetable)
		if ([e.day integerValue] == day && [e.sequence integerValue] == sequence) {
			for (TTPSubjectEntity *subj in e.subjects) {
				if ([subj.parity integerValue] == parity || [subj.parity integerValue] == 2)
					[result addObject:subj];
			}
		}

    return result;
}

- (NSString *)locationOnSingleSubgroupCount:(NSArray *)subgroups;
{
	if (subgroups.count == 1) {
		TTPSubgroup *sub = [subgroups objectAtIndex:0];
		return sub.location;
	}
	return NSLocalizedString(@"Multiple values", nil);
}

#pragma mark - Convert thing

- (NSString *)convertParityNumToString:(NSNumber *)parity;
{
	NSString *result = [NSString stringWithString:[self.parities objectAtIndex:[parity integerValue]]];
    return 	NSLocalizedString(result, nil);
}
 @end
