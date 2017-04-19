//
//  Event+CoreDataProperties.m
//  Fredit
//
//  Created by Codetector on 2017/4/19.
//  Copyright © 2017年 GuardianTechnologies. All rights reserved.
//

#import "Event+CoreDataProperties.h"

@implementation Event (CoreDataProperties)

+ (NSFetchRequest<Event *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Event"];
}

@dynamic changed;
@dynamic eventDescription;
@dynamic eventId;
@dynamic eventName;
@dynamic eventStatus;
@dynamic eventTime;
@dynamic inGroup;
@dynamic records;

@end
