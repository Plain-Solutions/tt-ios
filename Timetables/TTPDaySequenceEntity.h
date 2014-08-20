//
//  TTPDaySequenceEntity.h
//  Timetables
//
//  Created by Vladislav Slepukhin on 08/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 Entity to store timetable according to API v2.
 */
@interface TTPDaySequenceEntity : NSObject <NSCoding>

/**
 Number of the day from 0 to 5.
 */
@property (nonatomic, strong) NSNumber *day;

/**
 Sequence of the subject from 1 to 8.
 */
@property (nonatomic, strong) NSNumber *sequence;

/**
 Array of subjects on day and sequence for both (even and odd) weeks.
 */
@property (nonatomic, strong) NSArray *subjects;

- (id)initWithCoder:(NSCoder *)decoder;
- (void)encodeWithCoder:(NSCoder *)encoder;
- (NSString *)description;

@end
