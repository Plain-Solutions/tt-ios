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

- (id)init {
	self = [super init];
self.lessonBeginTimes = [NSArray arrayWithObjects:@"08:20", @"10:00", @"12:05", @"13:50", @"15:35", @"17:20", @"18:45", @"20:10", nil];
	
self.lessonEndTimes = [NSArray arrayWithObjects:@"09:50", @"11:35", @"13:40", @"15:25", @"17:10", @"18:40", @"20:05", @"21:30", nil];
	
	return self;
}
- (NSString *)getBeginTimeBySequence:(NSNumber *)sequence {
	return [self.lessonBeginTimes objectAtIndex: [[NSNumber numberWithInt:[sequence intValue] - 1] intValue]];
}

- (NSString *)getEndTimeBySequence:(NSNumber *)sequence {
	return [self.lessonEndTimes objectAtIndex: [[NSNumber numberWithInt:[sequence intValue] - 1] intValue]];
}

- (NSMutableArray *)getLessonsOnDayParity:(NSNumber *)day parity:(NSNumber *)parity {
	NSMutableArray *result = [[NSMutableArray alloc] init];
	for (TTPLesson *l  in self.timetable)
		if ([l.day isEqualToNumber:day] && ([l.parity isEqualToNumber:parity] || [l.parity intValue] == 2))
			[result addObject:l];

	return result;
}
 @end
