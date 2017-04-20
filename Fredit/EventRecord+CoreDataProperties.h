//
//  EventRecord+CoreDataProperties.h
//  Fredit
//
//  Created by Codetector on 2017/4/20.
//  Copyright © 2017年 GuardianTechnologies. All rights reserved.
//

#import "EventRecord+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface EventRecord (CoreDataProperties)

+ (NSFetchRequest<EventRecord *> *)fetchRequest;

@property (nonatomic) int32_t checkInTime;
@property (nonatomic) int64_t id;
@property (nonatomic) int32_t signupTime;
@property (nullable, nonatomic, retain) Event *event;
@property (nullable, nonatomic, retain) Student *student;

@end

NS_ASSUME_NONNULL_END
