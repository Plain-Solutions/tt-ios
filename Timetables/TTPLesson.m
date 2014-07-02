//
// Created by Vladislav Slepukhin on 04/06/14.
// Copyright (c) 2014 Plain Solution. All rights reserved.
//

#import "TTPLesson.h"


@implementation TTPLesson
@synthesize day = _day;
@synthesize sequence = _sequence;
@synthesize parity = _parity;
@synthesize name = _name;
@synthesize activity = _activity;
@synthesize subgroups = _subgroups;

+ (id)lessonWithLesson:(TTPLesson *)lesson {
	return [[[self class] alloc] initWithLesson:lesson];
}
- (id)initWithLesson:(TTPLesson *)lesson {
	self = [super init];
	self.day = lesson.day;
	self.sequence = lesson.sequence;
	self.parity = lesson.parity;
	self.name = lesson.name;
	self.activity = lesson.activity;
	[self.subgroups arrayByAddingObjectsFromArray:lesson.subgroups];
	return self;
}

@end