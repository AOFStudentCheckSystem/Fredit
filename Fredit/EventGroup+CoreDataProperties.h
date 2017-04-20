//
//  EventGroup+CoreDataProperties.h
//  Fredit
//
//  Created by Codetector on 2017/4/20.
//  Copyright © 2017年 GuardianTechnologies. All rights reserved.
//

#import "EventGroup+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface EventGroup (CoreDataProperties)

+ (NSFetchRequest<EventGroup *> *)fetchRequest;

@property (nonatomic) int64_t id;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) NSSet<Event *> *events;
@property (nullable, nonatomic, retain) NSSet<SignUpSheet *> *inSheets;

@end

@interface EventGroup (CoreDataGeneratedAccessors)

- (void)addEventsObject:(Event *)value;
- (void)removeEventsObject:(Event *)value;
- (void)addEvents:(NSSet<Event *> *)values;
- (void)removeEvents:(NSSet<Event *> *)values;

- (void)addInSheetsObject:(SignUpSheet *)value;
- (void)removeInSheetsObject:(SignUpSheet *)value;
- (void)addInSheets:(NSSet<SignUpSheet *> *)values;
- (void)removeInSheets:(NSSet<SignUpSheet *> *)values;

@end

NS_ASSUME_NONNULL_END
