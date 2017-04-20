//
//  SignUpSheet+CoreDataProperties.h
//  Fredit
//
//  Created by Codetector on 2017/4/20.
//  Copyright © 2017年 GuardianTechnologies. All rights reserved.
//

#import "SignUpSheet+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface SignUpSheet (CoreDataProperties)

+ (NSFetchRequest<SignUpSheet *> *)fetchRequest;

@property (nonatomic) int64_t id;
@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int32_t status;
@property (nullable, nonatomic, retain) EventGroup *eventGroups;

@end

NS_ASSUME_NONNULL_END
