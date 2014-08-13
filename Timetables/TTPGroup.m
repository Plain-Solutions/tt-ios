//
//  TTPGroup.m
//  Timetables
//
//  Created by Vladislav Slepukhin on 07/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import "TTPGroup.h"


@implementation TTPGroup

- (id)initWithAllInfo:(NSString *)departmentName tag:(NSString *)departmentTag name:(NSString *)groupName
{
	if (self = [super init]) {
		self.departmentName = departmentName;
		self.departmentTag = departmentTag;
		self.groupName = groupName;
	}
	
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.departmentName = [decoder decodeObjectForKey:@"departmentName"];
        self.departmentTag = [decoder decodeObjectForKey:@"departmentTag"];
        self.groupName = [decoder decodeObjectForKey:@"groupName"];
    }
	
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:self.departmentName forKey:@"departmentName"];
	[encoder encodeObject:self.departmentTag forKey:@"departmentTag"];
	[encoder encodeObject:self.groupName forKey:@"groupName"];
}

- (id)copy
{
	TTPGroup *copy = [[TTPGroup alloc] init];
	copy.departmentName = self.departmentName;
	copy.departmentTag = self.departmentTag;
	copy.groupName = self.groupName;

	return copy;
}

- (BOOL)isEqualTo:(TTPGroup *)group
{
	return ([self.departmentTag isEqualToString:group.departmentTag] &&
		[self.departmentName isEqualToString:group.departmentName] &&
		[self.groupName isEqualToString:group.groupName])?YES:NO;
}

@end
