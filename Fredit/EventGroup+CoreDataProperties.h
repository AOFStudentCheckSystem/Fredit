//
//  EventGroup+CoreDataProperties.h
//  
//
//  Created by Codetector on 2017/4/11.
//
//

#import "EventGroup+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface EventGroup (CoreDataProperties)

+ (NSFetchRequest<EventGroup *> *)fetchRequest;

@property (nonatomic) int64_t id;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) NSSet<Event *> *events;

@end

@interface EventGroup (CoreDataGeneratedAccessors)

- (void)addEventsObject:(Event *)value;
- (void)removeEventsObject:(Event *)value;
- (void)addEvents:(NSSet<Event *> *)values;
- (void)removeEvents:(NSSet<Event *> *)values;

@end

NS_ASSUME_NONNULL_END
