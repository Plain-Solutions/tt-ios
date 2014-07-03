//
// Created by Vladislav Slepukhin on 04/06/14.
// Copyright (c) 2014 Plain Solution. All rights reserved.
//

#import "TTPSubgroup.h"


@implementation TTPSubgroup {

}
@synthesize  subgroupName = _subgroupName;
@synthesize teacher = _teacher;
@synthesize location = _location;

- (NSString *)description;
{
	return [[NSString alloc] initWithFormat:@"Subgroup Name:%@\nSubgroup Location:%@\nSubgroup Teacher:%@\n---",
self.subgroupName, self.location, self.teacher];
}

@end