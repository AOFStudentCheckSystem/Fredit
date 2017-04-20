//
//  Event+CoreDataProperties.m
//  Fredit
//
//  Created by Codetector on 2017/4/20.
//  Copyright © 2017年 GuardianTechnologies. All rights reserved.
//

#import "Event+CoreDataProperties.h"

@implementation Event (CoreDataProperties)

+ (NSFetchRequest<Event *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Event"];
}

@dynamic eventDescription;
@dynamic eventId;
@dynamic eventName;
@dynamic eventStatus;
@dynamic eventTime;
@dynamic inGroup;
@dynamic records;

@end
