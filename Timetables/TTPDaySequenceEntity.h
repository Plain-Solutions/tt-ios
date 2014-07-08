//
//  TTPDaySequenceEntity.h
//  Timetables
//
//  Created by Vladislav Slepukhin on 08/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTPDaySequenceEntity : NSObject
@property (nonatomic, strong) NSNumber *day;
@property (nonatomic, strong) NSNumber *sequence;
@property (nonatomic, strong) NSArray *subjects;
@end
