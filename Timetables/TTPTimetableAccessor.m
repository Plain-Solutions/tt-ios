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
@synthesize availableActivities = _availableActivities;
@synthesize timetable = _timetable;
@synthesize availableDays = _availableDays;
@synthesize firstAvailableDay = _firstAvailableDay;
@synthesize lastAvailableDay = _lastAvailableDay;


- (id)init;
{
	self = [super init];
	[self initSets];
	return self;
}

- (id)initWithTimetable:(NSMutableArray *)timetable;
{
	self = [super init];
	[self initSets];
	self.timetable = timetable;
	return self;
}

- (void)initSets;
{
	self.lessonBeginTimes = [NSArray arrayWithObjects:@"08:20", @"10:00", @"12:05",
							 @"13:50", @"15:35", @"17:20", @"18:45", @"20:10", nil];
	
	self.lessonEndTimes = [NSArray arrayWithObjects:@"09:50", @"11:35", @"13:40",
						   @"15:25", @"17:10", @"18:40", @"20:05", @"21:30", nil];
	
	self.availableActivities = [NSArray arrayWithObjects:@"lecture", @"practice", @"lab", nil];
}

- (void)populateAvailableDays;
{
	self.availableDays = [[NSMutableArray alloc] init];
	for (int i = 0; i < 6; i++)
	{
		[self.availableDays addObject:[NSNumber numberWithInt:0]];
	}
	for (TTPLesson *l in self.timetable) {
		int value =[[self.availableDays objectAtIndex:[l.day intValue]] intValue];
		value++;
		[self.availableDays replaceObjectAtIndex:[l.day intValue] withObject:[NSNumber numberWithInt:value]];
	}

	for (int i = 0; i < self.availableDays.count; i++) {
		if ([[self.availableDays objectAtIndex:i] intValue] != 0) {
			self.firstAvailableDay = [NSNumber numberWithInt:i];
			break;
		}
	}
	NSLog(@"%@", self.firstAvailableDay);
		
	for (int i = self.availableDays.count - 1; i >= 0; i--) {
		if ([[self.availableDays objectAtIndex:i] intValue] != 0) {
			self.lastAvailableDay = [NSNumber numberWithInt:i];
			break;
		}
	}
		NSLog(@"%@", self.lastAvailableDay);
	NSLog(@"%@", [self.availableDays description]);

}

#pragma mark - Timey-wimey

- (NSString *)getBeginTimeBySequence:(NSNumber *)sequence;
{
	return [self.lessonBeginTimes objectAtIndex: [[NSNumber numberWithInt:[sequence intValue] - 1] intValue]];
}

- (NSString *)getEndTimeBySequence:(NSNumber *)sequence;
{
	return [self.lessonEndTimes objectAtIndex: [[NSNumber numberWithInt:[sequence intValue] - 1] intValue]];
}


- (NSNumber *)getNextDay:(int)currentDay;
{
	currentDay++;
	NSLog(@"%d", currentDay);
	if (currentDay >= self.availableDays.count)
			return self.firstAvailableDay;
	for (int i = currentDay; i < self.availableDays.count; i++) {
		if ([[self.availableDays objectAtIndex:i] intValue] != 0)
			return [NSNumber numberWithInt:i];
	}
	return self.firstAvailableDay;
}

- (NSNumber *)getPreviousDay:(int)currentDay;
{
	currentDay--;
	for (int i = currentDay; i >= 0; i--) {
		if ([[self.availableDays objectAtIndex:i] intValue] != 0)
			return [NSNumber numberWithInt:i];
	}
	return self.lastAvailableDay;
}

#pragma mark - Getting timetable

- (NSMutableArray *)getLessonsOnDayParity:(NSNumber *)day parity:(NSNumber *)parity withRepeats:(BOOL)isRepeated;
{
	NSMutableArray *result = [[NSMutableArray alloc] init];
	for (TTPLesson *l  in self.timetable)
		if ([l.day isEqualToNumber:day] && ([l.parity isEqualToNumber:parity] || [l.parity intValue] == 2))
			[result addObject:l];
		

	if (result.count != 0 && isRepeated == NO) {
	for (int i = 0; i < result.count-1; i++) {
		TTPLesson *current = [result objectAtIndex:i];
		TTPLesson *next = [result objectAtIndex:i+1];
		
		if (current.day == next.day && current.sequence == next.sequence && current.parity == next.parity) {
				current.name = @"Multiple values";
				[current.subgroups removeAllObjects];
				[result removeObject:next];
			}
		}
	}
	return result;
}

#pragma mark - Localisation thing

- (NSString *)localizeActivities:(NSString *)activity;
{
	
	NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
	if ([language isEqualToString:@"ru"]) {
		NSArray *russianNames = [NSArray arrayWithObjects:@"лекция", @"практика",
								 @"лабораторная", nil];
		return [russianNames objectAtIndex:[self.availableActivities indexOfObject:activity]];
	}
	return activity;
}
 @end
