//
//  FreditDataController.h
//  Fredit
//
//  Created by Codetector on 2017/4/11.
//  Copyright © 2017年 GuardianTechnologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef void (^VoidCallback)();

@interface FreditDataController : NSObject
@property (strong, nonatomic, readonly) NSPersistentContainer *persistentContainer;

- (instancetype)initWithCompletionBlock:(VoidCallback)callback;
@end
