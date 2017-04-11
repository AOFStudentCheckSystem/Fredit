//
//  Event+CoreDataClass.h
//  
//
//  Created by Codetector on 2017/4/11.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EventRecord;

NS_ASSUME_NONNULL_BEGIN

@interface Event : NSManagedObject

+ (instancetype) fetchOrCreateWithEventId: (NSString *)eventId inManagedObjectContext: (NSManagedObjectContext*) context;

@end

NS_ASSUME_NONNULL_END

#import "Event+CoreDataProperties.h"
