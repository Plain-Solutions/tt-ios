//
// Created by Vladislav Slepukhin on 22/05/14.
// Copyright (c) 2014 Plain Solution. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TTPDepartment : NSObject
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *tag;
@property(nonatomic, strong) NSString *msg;

- (id)initWithBasicInfo:(NSString *)name tag:(NSString *)tag;

- (id)initWithFullInfo:(NSString *)name tag:(NSString *)tag message:(NSString *)msg;

- (NSString *)description;

@end