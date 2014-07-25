//
//  TTPSubjectEntity.m
//  Timetables
//
//  Created by Vladislav Slepukhin on 08/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import "TTPSubjectEntity.h"

@implementation TTPSubjectEntity
@synthesize name = _name;
@synthesize activity = _activity;
@synthesize parity = _parity;
@synthesize subgroups = _subgroups;

- (id)initWithCoder:(NSCoder *)decoder;
{
	if (self = [super init]) {
		self.name = [decoder decodeObjectForKey:@"name"];
		self.activity = [decoder decodeObjectForKey:@"activity"];
		self.parity = [decoder decodeObjectForKey:@"parity"];
		self.subgroups = [decoder decodeObjectForKey:@"subgroups"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder;
{
	[encoder encodeObject:self.name forKey:@"name"];;
	[encoder encodeObject:self.activity forKey:@"activity"];
	[encoder encodeObject:self.parity forKey:@"parity"];
	[encoder encodeObject:self.subgroups forKey:@"subgroups"];
}

- (NSString *)description;
{
	NSMutableString *description = [[NSMutableString alloc] init];
	[description appendString:[NSString stringWithFormat:@"\tSubject name: %@\n\tActivity: %@\n\tParity: %@\n", self.name, self.activity, self.parity]];
	
	for (id subgroup in self.subgroups) {
		[description appendString:[subgroup description]];
	}
	return description;
}
@end
