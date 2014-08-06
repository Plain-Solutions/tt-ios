//
// Created by Vladislav Slepukhin on 22/05/14.
// Copyright (c) 2014 Plain Solution. All rights reserved.
//

#import "TTPDepartment.h"


@implementation TTPDepartment {

}

@synthesize name = _name;
@synthesize tag = _tag;


- (id)initWithNameTag:(NSString *)name tag:(NSString *)tag;
{
    self = [super init];
    if (self) {
        self.name = name;
        self.tag = tag;
    }

    return self;
}

- (NSString *)description;
{
    return [NSString stringWithFormat:@"Name: %@\nTag: %@\n",
                                      self.name, self.tag];
}


@end