//
//  Student+CoreDataProperties.h
//  Fredit
//
//  Created by Codetector on 2017/4/19.
//  Copyright © 2017年 GuardianTechnologies. All rights reserved.
//

#import "Student+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Student (CoreDataProperties)

+ (NSFetchRequest<Student *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *cardSecret;
@property (nullable, nonatomic, copy) NSString *firstName;
@property (nullable, nonatomic, copy) NSString *idNumber;
@property (nullable, nonatomic, copy) NSString *lastName;
@property (nullable, nonatomic, copy) NSString *preferredName;
@property (nullable, nonatomic, retain) NSSet<EventRecord *> *records;

@end

@interface Student (CoreDataGeneratedAccessors)

- (void)addRecordsObject:(EventRecord *)value;
- (void)removeRecordsObject:(EventRecord *)value;
- (void)addRecords:(NSSet<EventRecord *> *)values;
- (void)removeRecords:(NSSet<EventRecord *> *)values;

@end

NS_ASSUME_NONNULL_END
