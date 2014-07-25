//
// Created by Vladislav Slepukhin on 04/06/14.
// Copyright (c) 2014 Plain Solution. All rights reserved.
//

#import "TTPSubgroup.h"


@implementation TTPSubgroup {

}
@synthesize subgroupName = _subgroupName;
@synthesize teacher = _teacher;
@synthesize location = _location;


- (id)initWithCoder:(NSCoder *)decoder;
{
	if (self = [super init]) {
		self.subgroupName = [decoder decodeObjectForKey:@"subgroupName"];
		self.teacher = [decoder decodeObjectForKey:@"teacher"];
		self.location = [decoder decodeObjectForKey:@"location"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder;
{
	[encoder encodeObject:self.subgroupName forKey:@"subgroupName"];
	[encoder encodeObject:self.teacher forKey:@"teacher"];
	[encoder encodeObject:self.location forKey:@"location"];
}

- (NSString *)description;
{
	return [[NSString alloc] initWithFormat:@"\t\tSubgroup Name:%@\n\t\tSubgroup Location:%@\n\t\tSubgroup Teacher:%@\n-=-=-\n",
self.subgroupName, self.location, self.teacher];
}

@end