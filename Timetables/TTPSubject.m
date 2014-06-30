//
// Created by Vladislav Slepukhin on 04/06/14.
// Copyright (c) 2014 Plain Solution. All rights reserved.
//

#import "TTPSubject.h"
#import "TTPSubgroup.h"

@implementation TTPSubject {

}
@synthesize name = _name;
@synthesize activity = _activity;
@synthesize parity = _parity;
@synthesize subgroups = _subgroups;

- (NSString *)description {
    NSMutableString *result = [[NSMutableString alloc] init];
    NSString *str = [[NSString alloc] initWithFormat:@"Parirty: %@\nName:%@\nAcitvity:%@\n------\n", self.parity, self.name, self.activity];
    [result appendString:str];
    for (TTPSubgroup *gr in self.subgroups)  {
        [result appendString:[gr description]];

    }
    return result;
}

@end