//
// Created by Vladislav Slepukhin on 22/05/14.
// Copyright (c) 2014 Plain Solution. All rights reserved.
//

#import "TTPDepartment.h"


@implementation TTPDepartment

- (id)initWithNameTag:(NSString *)name tag:(NSString *)tag
{
    if (self = [super init]) {
        self.name = name;
        self.tag = tag;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Name: %@\nTag: %@\n",
                                      self.name, self.tag];
}

@end