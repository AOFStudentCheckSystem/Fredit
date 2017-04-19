//
//  Event+CoreDataClass.h
//  Fredit
//
//  Created by Codetector on 2017/4/19.
//  Copyright © 2017年 GuardianTechnologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EventGroup, EventRecord;

NS_ASSUME_NONNULL_BEGIN

@interface Event : NSManagedObject

+(instancetype)fetchOrCreateWithEventId:(NSString *)eventId inManagedObjectContext:(NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END

#import "Event+CoreDataProperties.h"
