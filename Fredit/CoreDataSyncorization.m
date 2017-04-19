//
//  CoreDataSyncorization.m
//  Fredit
//
//  Created by Codetector on 2017/4/19.
//  Copyright © 2017年 GuardianTechnologies. All rights reserved.
//

#import "CoreDataSyncorization.h"
#import <UIKit/UIKit.h>

@implementation CoreDataSyncorization

+ (instancetype)sharedSyncorization
{
    static CoreDataSyncorization *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CoreDataSyncorization alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

- (void) attemptFullSyncorization {
    
}

//- (void)

@end
