//
//  TrackableObject+CoreDataProperties.h
//  Fredit
//
//  Created by Codetector on 2017/4/20.
//  Copyright © 2017年 GuardianTechnologies. All rights reserved.
//

#import "TrackableObject+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TrackableObject (CoreDataProperties)

+ (NSFetchRequest<TrackableObject *> *)fetchRequest;

@property (nonatomic) int16_t changed;

@end

NS_ASSUME_NONNULL_END
