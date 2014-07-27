//
// Created by Vladislav Slepukhin on 22/05/14.
// Copyright (c) 2014 Plain Solution. All rights reserved.
//

#import "TTPDepartment.h"
#import "TTPSubgroup.h"
#import "TTPDaySequenceEntity.h"
#import "TTPSubjectEntity.h"
/**
 Incoming data parser.
 This thing deserialises JSON strings from api.sssutt.org to objects.
 */
@interface TTPParser : NSObject

- (NSMutableArray *)parseDepartments:(NSData *)raw error:(NSError *)error;

- (NSString *)prettifyDepartmentNames:(NSString *)departmentName trim:(BOOL)trim;

- (NSString *)parseError:(NSData *)raw error:(NSError *)error;

- (NSString *)parseDownloadedMessageForDepartment:(NSData *)raw error:(NSError *)error;

- (NSMutableArray *)parseGroups:(NSData *)raw error:(NSError *)error;

- (NSMutableArray *)parseTimetables:(NSData *)raw error:(NSError *)error;
@end