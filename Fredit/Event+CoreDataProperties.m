//
//  Event+CoreDataProperties.m
//  
//
//  Created by Codetector on 2017/4/11.
//
//

#import "Event+CoreDataProperties.h"

@implementation Event (CoreDataProperties)

+ (NSFetchRequest<Event *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Event"];
}

@dynamic eventDescription;
@dynamic eventId;
@dynamic eventStatus;
@dynamic eventTime;
@dynamic id;
@dynamic eventName;
@dynamic records;

@end
