//
//  FreditDataAccessObject.h
//  Fredit
//
//  Created by Codetector on 2017/4/15.
//  Copyright © 2017年 GuardianTechnologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface FreditDataAccessObject : NSObject

+ (void) updateAllEventsFromServerInContext: (NSManagedObjectContext*) context;

@end
