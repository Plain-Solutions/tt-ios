//
// Created by Vladislav Slepukhin on 22/05/14.
// Copyright (c) 2014 Plain Solution. All rights reserved.
//

#import "TTPParser.h"


@implementation TTPParser {

}
- (NSMutableArray *)parseDepartments:(NSData *)raw error:(NSError *)error {
    NSMutableArray *result = [[NSMutableArray alloc] init];

    NSArray *asArray = [NSJSONSerialization
            JSONObjectWithData:raw
                       options:NSJSONReadingMutableContainers
                         error:&error];
    for (NSDictionary *elem in asArray) {
        TTPDepartment *dep = [[TTPDepartment alloc] initWithBasicInfo:[elem objectForKey:@"name"] tag:[elem objectForKey:@"tag"]];
        [result addObject:dep];
    }
    return result;
}

- (NSString *) prettifyDepartmentNames:(NSString *)departmentName
{
    NSString *truncateDepEnding = [departmentName stringByReplacingOccurrencesOfString:@"факультет" withString:@""];
    NSString *truncateDepBeginning = [truncateDepEnding stringByReplacingOccurrencesOfString:@"Факультет" withString:@""];
    NSString *truncateInstitute = [truncateDepBeginning stringByReplacingOccurrencesOfString:@"Институт" withString:@""];
    NSString *trimSpaced = [truncateInstitute stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    return [trimSpaced capitalizedString];
}



/*- (NSString *)parseDownloadedMessageForDepartment:(NSData *)raw :(NSError *)error; {
    NSDictionary *asDict = [NSJSONSerialization JSONObjectWithData:raw options:0 error:&error];
    return [asDict objectForKey:@"msg"];
}

- (NSMutableArray *)parseGroups:(NSData *)raw :(NSError *)error {
    NSArray *asArray = [NSJSONSerialization
            JSONObjectWithData:raw
                       options:NSJSONReadingMutableContainers
                         error:&error];

    return [asArray mutableCopy];
}*/

/*- (NSMutableArray *)parseTimetables:(NSData *)raw :(NSError *)error {
    NSMutableArray *result = [[NSMutableArray alloc] init];

    NSArray *asArray = [NSJSONSerialization
            JSONObjectWithData:raw
                       options:NSJSONReadingMutableContainers
                         error:&error];
    for (NSDictionary *lesson in asArray) {
        TTPLesson *aLesson = [[TTPLesson alloc] init];
        aLesson.day = [NSNumber numberWithInt:[self convertDayToNum:
                lesson[@"day"]]];
        aLesson.parity = [NSNumber numberWithInt:[self convertParityToNum:
                lesson[@"parity"]]];
        aLesson.sequence = [NSNumber numberWithInt:[lesson[@"sequence"] intValue]];

        NSMutableArray *allSubjects = [[NSMutableArray alloc] init];
        for (NSDictionary *subj in lesson[@"subject"]) {
            TTPSubject *aSubject = [[TTPSubject alloc] init];
            aSubject.activity = subj[@"activity"];
            aSubject.name = subj[@"name"];

            NSMutableArray *allSubGroups = [[NSMutableArray alloc] init];
            for (NSDictionary *gr in subj[@"subgroups"]) {
                TTPSubgroup *aSubGroup = [[TTPSubgroup alloc] init];
                aSubGroup.subgroup_name = gr[@"subgroup"];
                aSubGroup.teacher = gr[@"teacher"];
                aSubGroup.location = gr[@"location"];

                [allSubGroups addObject:aSubGroup];
            }
            aSubject.subgroups = allSubGroups;
            [allSubjects addObject:aSubject];
        }

        aLesson.subject = allSubjects;
        [result addObject:aLesson];
    }

    return result;

}

- (int)convertDayToNum:(NSString *)day {
    if ([day isEqualToString:@"mon"])
        return 1;
    if ([day isEqualToString:@"tue"])
        return 2;
    if ([day isEqualToString:@"wed"])
        return 3;
    if ([day isEqualToString:@"thu"])
        return 4;
    if ([day isEqualToString:@"fri"])
        return 5;
    //otherwise:
    return 6;
}

- (int)convertParityToNum:(NSString *)parity {
    if ([parity isEqualToString:@"denom"])
        return -1;
    if ([parity isEqualToString:@"nom"])
        return 1;
    //if full
    return 0;
}*/


@end