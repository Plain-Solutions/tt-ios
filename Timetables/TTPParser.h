//
// Created by Vladislav Slepukhin on 22/05/14.
// Copyright (c) 2014 Plain Solution. All rights reserved.
//

#import "TTPDepartment.h"
//#import "TTPLesson.h"
//#import "TTPSubject.h"
//#import "TTPSubgroup.h"


@interface TTPParser : NSObject

- (NSMutableArray *)parseDepartments:(NSData *)raw error:(NSError *)error;

- (NSString *) prettifyDepartmentNames:(NSString *)departmentName;

//- (NSString *)parseDownloadedMessageForDepartment:(NSData *)raw:(NSError *)error;
//
- (NSMutableArray *)parseGroups:(NSData *)raw error:(NSError *)error;
//
//- (NSMutableArray *)parseTimetables:(NSData *)raw:(NSError *)error;
@end