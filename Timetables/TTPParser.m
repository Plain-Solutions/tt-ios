//
// Created by Vladislav Slepukhin on 22/05/14.
// Copyright (c) 2014 Plain Solution. All rights reserved.
//

#import "TTPParser.h"


@implementation TTPParser {

}
- (NSMutableArray *)parseDepartments:(NSData *)raw error:(NSError *)error;
{
    NSMutableArray *result = [[NSMutableArray alloc] init];

    NSArray *asArray = [NSJSONSerialization
            JSONObjectWithData:raw
                       options:NSJSONReadingMutableContainers
                         error:&error];
    for (NSDictionary *elem in asArray) {
        TTPDepartment *dep = [[TTPDepartment alloc] initWithBasicInfo:[elem objectForKey:@"name"]
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

/*
 - (NSString *)parseDownloadedMessageForDepartment:(NSData *)raw :(NSError *)error; {
    NSDictionary *asDict = [NSJSONSerialization JSONObjectWithData:raw options:0 error:&error];
    return [asDict objectForKey:@"msg"];
}
*/

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
		for (NSDictionary *subject in lesson[@"subject"]) {
			TTPLesson *aLesson = [[TTPLesson alloc] init];
			aLesson.day = lesson[@"day"];
			aLesson.sequence = lesson[@"sequence"];
			aLesson.parity = subject[@"parity"];
			aLesson.name = subject[@"name"];
			aLesson.activity = subject[@"activity"];

			aLesson.subgroups = [[NSMutableArray alloc] init];
			for (NSDictionary *aSubgroup in subject[@"subgroups"]) {
				TTPSubgroup *subgroup = [[TTPSubgroup alloc] init];
				
				subgroup.subgroupName = aSubgroup[@"subgroup"];
				subgroup.teacher = aSubgroup[@"teacher"];
				subgroup.location = aSubgroup[@"location"];
				
				[aLesson.subgroups addObject:subgroup];
			}
			
			[result addObject:aLesson];
			
		}
		

    }
	
    return result;
	
}

@end