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

+(id)sharedAccessor
{
	static TTPTimetableAccessor *sharedAccessor;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedAccessor = [[self alloc] init];
	});
	return sharedAccessor;
}

- (id)init;
{
	if (self = [super init]) {
	self.lessonBeginTimes = [NSArray arrayWithObjects:@"08:20", @"10:00", @"12:05",
							 @"13:50", @"15:35", @"17:20", @"18:45", @"20:10", nil];
	
	self.lessonEndTimes = [NSArray arrayWithObjects:@"09:50", @"11:35", @"13:40",
						   @"15:25", @"17:10", @"18:40", @"20:05", @"21:30", nil];
	
	self.parities = [NSArray arrayWithObjects:@"even", @"odd", @"even&odd", nil];
	}
	
	return self;
}

- (void)populateAvailableDays
{
	self.availableDays = [[NSMutableArray alloc] init];

	NSMutableSet *sDays = [[NSMutableSet alloc] init];
	for (TTPDaySequenceEntity *e in self.timetable) {
		[sDays addObject:e.day];
	}
	NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES selector:nil];

	NSArray *days = [[NSArray arrayWithArray:[sDays allObjects]] sortedArrayUsingDescriptors:@[sortDescriptor]];
	for (NSNumber *num in days) {
		NSInteger i = [num integerValue];
		struct __dayParityEntity dpe;
		dpe.day = i;

		NSMutableArray *__day = [[NSMutableArray alloc] init];
		for (TTPDaySequenceEntity *e in self.timetable)
			if ([e.day integerValue] == i)
				[__day addObject:e];
		for (TTPDaySequenceEntity *e in __day) {
			BOOL hasFoundEven, hasFoundOdd;
			hasFoundEven = hasFoundOdd = NO;
			
			for (TTPSubjectEntity *subj in e.subjects) {
				if ([subj.parity integerValue] == 2) {
					hasFoundEven = hasFoundOdd = YES;
					break;
				}
				if ([subj.parity integerValue] == 1) {
					hasFoundOdd = YES;
				}
				if (![subj.parity integerValue]) {
					hasFoundEven = YES;
				}
			}
			
			if (hasFoundEven && hasFoundOdd)
				dpe.parity = AllWeekSubject;
			else if (hasFoundEven && !hasFoundOdd)
				dpe.parity = EvenSubject;
			else if (hasFoundOdd && !hasFoundEven)
				dpe.parity = OddSubject;
		}
		[self.availableDays  addObject:[NSValue valueWithBytes:&dpe objCType:@encode(struct __dayParityEntity)]];
	}
	
		for (int i = 0; i < self.availableDays.count; i++) {
		struct __dayParityEntity e;
		[self.availableDays[i] getValue:&e];
		
	}
}

#pragma mark - Timey-wimey

- (NSString *)beginTimeBySequence:(NSNumber *)sequence
{
	return [self.lessonBeginTimes objectAtIndex: [[NSNumber numberWithInt:[sequence intValue] - 1] intValue]];
}

- (NSString *)endTimeBySequence:(NSNumber *)sequence
{
	return [self.lessonEndTimes objectAtIndex: [[NSNumber numberWithInt:[sequence intValue] - 1] intValue]];
}
- (NSString *)timeRangeBySequence:(NSNumber *)sequence
{
    // will be formated as 00:00 - 00:00
    return [NSString stringWithFormat:@"%@ – %@",
			[self beginTimeBySequence:sequence], [self endTimeBySequence:sequence]];
}

- (struct __dayParityEntity)nextDay:(NSInteger)currentDay
{
	NSInteger index = -1;
	
	struct __dayParityEntity dpe;
	for (int i = 0; i < self.availableDays.count; i++) {
		[self.availableDays[i] getValue:&dpe];
		if (dpe.day == currentDay) {
			index = i;
			break;
		}
	}
	index++;
	if (index >= self.availableDays.count)
		[[self.availableDays firstObject] getValue:&dpe];
	else
		[self.availableDays[index] getValue:&dpe];

	return dpe;
}

- (struct __dayParityEntity)previousDay:(NSInteger)currentDay
{
	NSInteger index = -1;

	struct __dayParityEntity dpe;
	for (int i = 0; i < self.availableDays.count; i++) {

		[self.availableDays[i] getValue:&dpe];
		if (dpe.day == currentDay) {
			index = i;
			break;
		}
	}
	index--;
	if (index < 0)
		[[self.availableDays lastObject] getValue:&dpe];
	else
		[self.availableDays[index] getValue:&dpe];
	return dpe;
}

#pragma mark - Getting timetables on specific DP/DPS

- (NSInteger)lessonsCountOnDayParity:(NSInteger)day parity:(NSInteger)parity
{
	NSInteger count = 0;

	for (TTPDaySequenceEntity *e  in self.timetable) {
		BOOL addDPT = NO;
		if ([e.day integerValue] == day) {
			for (TTPSubjectEntity *subj in e.subjects) {
				if ([subj.parity integerValue] == parity || [subj.parity integerValue] == AllWeekSubject) {
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
- (NSInteger)lessonsCountOnDayParitySequence:(NSInteger)day parity:(NSInteger)parity sequence:(NSInteger)sequence
{
	NSInteger count = 0;

	for (TTPDaySequenceEntity *e  in self.timetable) {
		if ([e.day integerValue] == day && [e.sequence integerValue] == sequence) {
			for (TTPSubjectEntity *subj in e.subjects) {
				if ([subj.parity integerValue] == parity || [subj.parity integerValue] == AllWeekSubject)
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
				if ([subj.parity integerValue] == parity || [subj.parity integerValue] == AllWeekSubject)
					[result addObject:e.sequence];
			}
		}
	}
	
	return [[NSArray alloc] initWithArray:[[result allObjects] sortedArrayUsingSelector:@selector(compare:)]];
}

- (NSArray *)lessonsOnDayParitySequence:(NSInteger)day parity:(NSInteger)parity sequence:(NSInteger)sequence
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
	for (TTPDaySequenceEntity *e  in self.timetable)
		if ([e.day integerValue] == day && [e.sequence integerValue] == sequence) {
			for (TTPSubjectEntity *subj in e.subjects) {
				if ([subj.parity integerValue] == parity || [subj.parity integerValue] == AllWeekSubject)
					[result addObject:subj];
			}
		}

    return result;
}

#pragma mark - Converting and styling

- (NSString *)locationOnSingleSubgroupCount:(NSArray *)subgroups
{
	if (subgroups.count == 1) {
		TTPSubgroup *sub = [subgroups objectAtIndex:0];
		return sub.location;
	}
	return NSLocalizedString(@"Multiple values", nil);
}

- (NSString *)convertParityNumToString:(NSNumber *)parity
{
	NSString *result = [NSString stringWithString:[self.parities objectAtIndex:[parity integerValue]]];
	return 	NSLocalizedString(result, nil);
}

@end
