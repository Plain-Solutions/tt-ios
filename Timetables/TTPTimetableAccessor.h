//
//  TTPTimetableAccessor.h
//  Timetables
//
//  Created by Vladislav Slepukhin on 02/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTPSubgroup.h"
#import "TTPLesson.h"

@interface TTPTimetableAccessor : NSObject
@property (nonatomic, strong) NSArray *lessonBeginTimes;
@property (nonatomic, strong) NSArray *lessonEndTimes;
@property (nonatomic, strong) NSMutableArray *timetable;

- (NSString *)getBeginTimeBySequence:(NSNumber *)sequence;
- (NSString *)getEndTimeBySequence:(NSNumber *)sequence;
- (NSMutableArray *)getLessonsOnDayParity:(NSNumber *)day parity:(NSNumber *)partiy;
@end
