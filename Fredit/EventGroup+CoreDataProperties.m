//
//  EventGroup+CoreDataProperties.m
//  
//
//  Created by Codetector on 2017/4/11.
//
//

#import "EventGroup+CoreDataProperties.h"

@implementation EventGroup (CoreDataProperties)

+ (NSFetchRequest<EventGroup *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"EventGroup"];
}

@dynamic id;
@dynamic name;
@dynamic events;

@end
