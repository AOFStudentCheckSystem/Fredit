//
//  Student+CoreDataClass.m
//  Fredit
//
//  Created by Codetector on 2017/4/19.
//  Copyright © 2017年 GuardianTechnologies. All rights reserved.
//

#import "Student+CoreDataClass.h"
#import "EventRecord+CoreDataClass.h"

@implementation Student

+(instancetype)fetchOrCreateWithStudentId:(NSString *)studentId inManagedObjectContext:(NSManagedObjectContext *)context {
    
    // Fetch or Create root user data managed object
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setPredicate:[NSPredicate predicateWithFormat:@"idNumber = %@" argumentArray:@[studentId]]];
    
    [request setEntity:entityDescription];
    
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];
    
    if (result == nil) {
        NSLog(@"fetch result = nil");
        // Handle the error here
    } else {
        if([result count] > 0) {
            return (Student *)[result objectAtIndex:0];
        } else {
            Student* newEvent = (Student *)[NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:context];
            newEvent.changed = 1;
            NSLog(@"Created Student");
            return newEvent;
        }
    }
    return nil;
}

- (NSString *) lastnameInitial {
    [self willAccessValueForKey:@"lastnameInitial"];
    NSString * initial = [[self lastName]substringToIndex:1];
    [self didAccessValueForKey:@"lastnameInitial"];
    return initial;
}

@end
