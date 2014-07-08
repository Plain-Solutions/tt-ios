//
// Created by Vladislav Slepukhin on 22/05/14.
// Copyright (c) 2014 Plain Solution. All rights reserved.
//

#import "TTPParser.h"


@implementation TTPParser

- (NSMutableArray *)parseDepartments:(NSData *)raw error:(NSError *)error;
{
    NSMutableArray *result = [[NSMutableArray alloc] init];

    NSArray *asArray = [NSJSONSerialization
            JSONObjectWithData:raw
                       options:NSJSONReadingMutableContainers
                         error:&error];
    for (NSDictionary *elem in asArray) {
        TTPDepartment *dep = [[TTPDepartment alloc] initWithNameTag:[elem objectForKey:@"name"]
																  tag:[elem objectForKey:@"tag"]];
        [result addObject:dep];
    }
    return result;
}

// this is used in Department view to minimize text and hold them in the single line
- (NSString *)prettifyDepartmentNames:(NSString *)departmentName;
{
    NSString *truncateDepEnding = [departmentName stringByReplacingOccurrencesOfString:@"факультет"
																			withString:@""];
    NSString *truncateDepBeginning = [truncateDepEnding stringByReplacingOccurrencesOfString:@"Факультет"
																				  withString:@""];
    NSString *truncateInstitute = [truncateDepBeginning stringByReplacingOccurrencesOfString:@"Институт"
																				  withString:@""];
    NSString *trimSpaced = [truncateInstitute stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    return [trimSpaced capitalizedString];
}


 - (NSString *)parseDownloadedMessageForDepartment:(NSData *)raw error:(NSError *)error; {
    NSDictionary *asDict = [NSJSONSerialization JSONObjectWithData:raw options:0 error:&error];
    return [asDict objectForKey:@"msg"];
}


- (NSMutableArray *)parseGroups:(NSData *)raw error:(NSError *)error;
{
    NSArray *asArray = [NSJSONSerialization
            JSONObjectWithData:raw
                       options:NSJSONReadingMutableContainers
                         error:&error];

    return [asArray mutableCopy];
}

- (NSMutableArray *)parseTimetables:(NSData *)raw error:(NSError *)error;
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
	
    NSArray *asArray = [NSJSONSerialization
						JSONObjectWithData:raw
						options:NSJSONReadingMutableContainers
						error:&error];
    for (NSDictionary *lesson in asArray) {
		TTPDaySequenceEntity *dse = [[TTPDaySequenceEntity alloc] init];
		dse.day = lesson[@"day"];
		dse.sequence = lesson[@"sequence"];
		NSMutableArray *subjects = [[NSMutableArray alloc] init];
		for (NSDictionary *subject in lesson[@"subject"]) {
			TTPSubjectEntity *_subj = [[TTPSubjectEntity alloc] init];
			_subj.name = subject[@"name"];
			_subj.activity = subject[@"activity"];
			_subj.parity = subject[@"parity"];
			
			NSMutableArray *subgroups = [[NSMutableArray alloc] init];
			for (NSDictionary *subgroup in subject[@"subgroups"]) {
				TTPSubgroup *_subg = [[TTPSubgroup alloc] init];
				_subg.subgroupName = subgroup[@"subgroup"];
				_subg.teacher = subgroup[@"teacher"];
				_subg.location = subgroup[@"location"];
				[subgroups addObject:_subg];
			}
			_subj.subgroups = [[NSArray alloc] initWithArray:subgroups];
			[subjects addObject:_subj];
		}
		dse.subjects = [[NSArray alloc] initWithArray:subjects];

		[result addObject:dse];
	}
	
    return result;
	
}

@end