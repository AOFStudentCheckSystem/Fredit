//
//  EventRecord+CoreDataProperties.m
//  
//
//  Created by Codetector on 2017/4/11.
//
//

#import "EventRecord+CoreDataProperties.h"

@implementation EventRecord (CoreDataProperties)

+ (NSFetchRequest<EventRecord *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"EventRecord"];
}

@dynamic checkInTime;
@dynamic id;
@dynamic signupTime;
@dynamic event;
@dynamic student;

@end
