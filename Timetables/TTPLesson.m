//
// Created by Vladislav Slepukhin on 04/06/14.
// Copyright (c) 2014 Plain Solution. All rights reserved.
//

#import "TTPLesson.h"
#import "TTPSubject.h"

@implementation TTPLesson {

}
@synthesize day = _day;
@synthesize sequence = _sequence;
@synthesize subjects = _subjects;

- (NSString *)description {
    NSMutableString *res = [[NSMutableString alloc ] init];
    NSString *str = [[NSString alloc] initWithFormat:@"Day: %@\n Sequence: %@\n"
            , self.day, self.sequence];
    [res appendString:str];
    for (TTPSubject *subj in self.subjects) {
        [res appendString:[subj description]];
    }
    [res appendString:@"-----\n"];

    return res;
}

@end