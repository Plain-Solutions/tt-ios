//
//  TTPGroup.m
//  Timetables
//
//  Created by Vladislav Slepukhin on 07/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import "TTPGroup.h"

@implementation TTPGroup

@synthesize departmentName = _departmentName;
@synthesize departmentTag = _departmentTag;
@synthesize groupName = _groupName;

- (id)initWithAllInfo:(NSString *)departmentName tag:(NSString *)departmentTag name:(NSString *)groupName;
{
	if (self = [super init]) {
		self.departmentName = departmentName;
		self.departmentTag = departmentTag;
		self.groupName = groupName;
	}
	
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder;
{
    if(self = [super init]) {
        self.departmentName = [decoder decodeObjectForKey:@"departmentName"];
        self.departmentTag = [decoder decodeObjectForKey:@"departmentTag"];
        self.groupName = [decoder decodeObjectForKey:@"groupName"];
    }
    return self;
}

- (id) copy;
{
	TTPGroup *copy = [[TTPGroup alloc] init];
	copy.departmentName = self.departmentName;
	copy.departmentTag = self.departmentTag;
	copy.groupName = self.groupName;

	return copy;
}

- (void)encodeWithCoder:(NSCoder *)encoder;
{
    [encoder encodeObject:self.departmentName forKey:@"departmentName"];
    [encoder encodeObject:self.departmentTag forKey:@"departmentTag"];
    [encoder encodeObject:self.groupName forKey:@"groupName"];
}

@end
