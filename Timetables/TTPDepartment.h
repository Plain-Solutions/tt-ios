//
// Created by Vladislav Slepukhin on 22/05/14.
// Copyright (c) 2014 Plain Solution. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Entity of department.
 Fetched from api.ssutt.org and deserialised from JSON
 */
@interface TTPDepartment : NSObject

/**
 The printed name.
 */
@property (nonatomic, strong) NSString *name;

/**
 The tag like 'knt' or 'bf' for navigation and interconnection.
 */
@property (nonatomic, strong) NSString *tag;

- (id)initWithNameTag:(NSString *)name tag:(NSString *)tag;

- (NSString *)description;

@end