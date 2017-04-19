//
//  EventGroup+CoreDataProperties.m
//  Fredit
//
//  Created by Codetector on 2017/4/19.
//  Copyright © 2017年 GuardianTechnologies. All rights reserved.
//

#import "EventGroup+CoreDataProperties.h"

@implementation EventGroup (CoreDataProperties)

+ (NSFetchRequest<EventGroup *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"EventGroup"];
}

@dynamic id;
@dynamic name;
@dynamic events;
@dynamic inSheets;

@end
