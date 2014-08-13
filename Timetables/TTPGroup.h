//
//  TTPGroup.h
//  Timetables
//
//  Created by Vladislav Slepukhin on 07/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 An entity to store user parameters in NSUserDefaults and
 fancier data transition between views.
 */
@interface TTPGroup : NSObject <NSCoding>

/**
 The department full name.
 */
@property (nonatomic, strong) NSString *departmentName;

/**
 The department tag to navigate trough API ('knt', 'bf').
 */
@property (nonatomic, strong) NSString *departmentTag;

/**
 Group name like 151 or so.
 */
@property (nonatomic, strong) NSString *groupName;

- (id)initWithAllInfo:(NSString *)departmentName tag:(NSString *)departmentTag name:(NSString *)groupName;
- (id)initWithCoder:(NSCoder *)decoder;
- (void)encodeWithCoder:(NSCoder *)encoder;
- (id)copy;

@end
