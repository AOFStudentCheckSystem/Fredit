//
//  Student+CoreDataClass.h
//  Fredit
//
//  Created by Codetector on 2017/4/19.
//  Copyright © 2017年 GuardianTechnologies. All rights reserved.
//
#import "TrackableObject+CoreDataClass.h"
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EventRecord;

NS_ASSUME_NONNULL_BEGIN

@interface Student : TrackableObject

+(instancetype)fetchOrCreateWithStudentId:(NSString *)studentId inManagedObjectContext:(NSManagedObjectContext *)context ;

- (NSString *) lastnameInitial;
@end

NS_ASSUME_NONNULL_END

#import "Student+CoreDataProperties.h"
