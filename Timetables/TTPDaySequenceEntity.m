
//
//  TTPDaySequenceEntity.m
//  Timetables
//
//  Created by Vladislav Slepukhin on 08/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import "TTPDaySequenceEntity.h"

@implementation TTPDaySequenceEntity
@synthesize  day = _day;
@synthesize sequence = _sequence;
@synthesize subjects = _subjects;

- (id)initWithCoder:(NSCoder *)decoder {
	if (self = [super init]) {
		self.day = [decoder decodeObjectForKey:@"day"];
		self.sequence = [decoder decodeObjectForKey:@"sequence"];
		self.subjects = [decoder decodeObjectForKey:@"subjects"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:self.day forKey:@"day"];
	[encoder encodeObject:self.sequence forKey:@"sequence"];
	[encoder encodeObject:self.subjects forKey:@"subjects"];
}

- (NSString *)description;
{
	NSMutableString *description = [[NSMutableString alloc] init];
  	[description appendString:[NSString stringWithFormat:@"=====\nDay:%d\nSequence:%d\n", [self.day intValue],
						[self.sequence intValue]]];

	for (id subject in self.subjects) {
		[description appendString:[subject description]];
	}
	[description appendString:@"\n====="];
	return description;
}
@end
