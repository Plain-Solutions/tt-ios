//
// Created by Vladislav Slepukhin on 22/05/14.
// Copyright (c) 2014 Plain Solution. All rights reserved.
//

#import "TTPDepartment.h"


@implementation TTPDepartment {

}

@synthesize name = _name;
@synthesize tag = _tag;
@synthesize msg = _msg;


- (id)initWithBasicInfo:(NSString *)name tag:(NSString *)tag;
{
    self = [super init];
    if (self) {
        self.name = name;
        self.tag = tag;
    }

    return self;
}

- (id)initWithFullInfo:(NSString *)name tag:(NSString *)tag message:(NSString *)msg;
{
    self = [super init];
    if (self) {
        self.name = name;
        self.tag = tag;
        self.msg = msg;
    }

    return self;
}

- (void)setMessage:(NSString *)msg;
{
    self.msg = msg;
}

- (NSString *)description;
{
    return [NSString stringWithFormat:@"Name: %@\nTag: %@\nMessage: %@\n\n",
                                      self.name, self.tag, self.msg];
}


@end