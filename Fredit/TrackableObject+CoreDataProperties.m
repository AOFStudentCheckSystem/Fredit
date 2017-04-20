//
//  TrackableObject+CoreDataProperties.m
//  Fredit
//
//  Created by Codetector on 2017/4/20.
//  Copyright © 2017年 GuardianTechnologies. All rights reserved.
//

#import "TrackableObject+CoreDataProperties.h"

@implementation TrackableObject (CoreDataProperties)

+ (NSFetchRequest<TrackableObject *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TrackableObject"];
}

@dynamic changed;

@end
