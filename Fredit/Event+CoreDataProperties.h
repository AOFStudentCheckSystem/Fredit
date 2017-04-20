//
//  Event+CoreDataProperties.h
//  Fredit
//
//  Created by Codetector on 2017/4/20.
//  Copyright © 2017年 GuardianTechnologies. All rights reserved.
//

#import "Event+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Event (CoreDataProperties)

+ (NSFetchRequest<Event *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *eventDescription;
@property (nullable, nonatomic, copy) NSString *eventId;
@property (nullable, nonatomic, copy) NSString *eventName;
@property (nonatomic) int32_t eventStatus;
@property (nullable, nonatomic, copy) NSDate *eventTime;
@property (nullable, nonatomic, retain) NSSet<EventGroup *> *inGroup;
@property (nullable, nonatomic, retain) NSSet<EventRecord *> *records;

@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addInGroupObject:(EventGroup *)value;
- (void)removeInGroupObject:(EventGroup *)value;
- (void)addInGroup:(NSSet<EventGroup *> *)values;
- (void)removeInGroup:(NSSet<EventGroup *> *)values;

- (void)addRecordsObject:(EventRecord *)value;
- (void)removeRecordsObject:(EventRecord *)value;
- (void)addRecords:(NSSet<EventRecord *> *)values;
- (void)removeRecords:(NSSet<EventRecord *> *)values;

@end

NS_ASSUME_NONNULL_END
