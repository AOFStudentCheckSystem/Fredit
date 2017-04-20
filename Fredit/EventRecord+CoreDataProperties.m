//
//  EventRecord+CoreDataProperties.m
//  Fredit
//
//  Created by Codetector on 2017/4/20.
//  Copyright © 2017年 GuardianTechnologies. All rights reserved.
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
