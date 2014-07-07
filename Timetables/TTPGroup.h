//
//  TTPGroup.h
//  Timetables
//
//  Created by Vladislav Slepukhin on 07/07/14.
//  Copyright (c) 2014 Vlad Slepukhin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTPGroup : NSObject <NSCoding>
@property (nonatomic, strong) NSString *departmentName;
@property (nonatomic, strong) NSString *departmentTag;
@property (nonatomic, strong) NSString *groupName;

- (NSString *)departmentName;
- (NSString *)departmentTag;
- (NSString *)groupName;

- (id)initWithAllInfo:(NSString *)departmentName tag:(NSString *)departmentTag name:(NSString *)groupName;
- (id)initWithCoder:(NSCoder *)decoder;

- (void)encodeWithCoder:(NSCoder *)encoder;

- (BOOL)isSaved:(NSArray *)favGroups;
@end
