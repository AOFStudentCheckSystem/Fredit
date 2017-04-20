//
//  CoreDataSyncorization.h
//  Fredit
//
//  Created by Codetector on 2017/4/19.
//  Copyright © 2017年 GuardianTechnologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataSyncorization : NSObject

+ (instancetype)sharedSyncorization;

- (void) attemptFullSyncorization: (void (^)())complete ;

@end
