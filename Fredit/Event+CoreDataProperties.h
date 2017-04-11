//
//  Event+CoreDataProperties.h
//  
//
//  Created by Codetector on 2017/4/11.
//
//

#import "Event+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Event (CoreDataProperties)

+ (NSFetchRequest<Event *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *eventDescription;
@property (nullable, nonatomic, copy) NSString *eventId;
@property (nonatomic) int32_t eventStatus;
@property (nullable, nonatomic, copy) NSDate *eventTime;
@property (nonatomic) int64_t id;
@property (nullable, nonatomic, retain) NSSet<EventRecord *> *records;

@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addRecordsObject:(EventRecord *)value;
- (void)removeRecordsObject:(EventRecord *)value;
- (void)addRecords:(NSSet<EventRecord *> *)values;
- (void)removeRecords:(NSSet<EventRecord *> *)values;

@end

NS_ASSUME_NONNULL_END
