//
//  CoreDataSyncorization.m
//  Fredit
//
//  Created by Codetector on 2017/4/19.
//  Copyright © 2017年 GuardianTechnologies. All rights reserved.
//

#import "CoreDataSyncorization.h"
#import "AppDelegate.h"
#import "FreditAPI.h"
#import "Event+CoreDataClass.h"
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CoreDataSyncorization()

@property (atomic) bool isSyncing;

@end

@implementation CoreDataSyncorization

+ (instancetype)sharedSyncorization
{
    static CoreDataSyncorization *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CoreDataSyncorization alloc] init];
        sharedInstance.isSyncing = false;
        [[NSNotificationCenter defaultCenter] addObserver:sharedInstance selector:@selector(onCoreDataStoreChanged:) name:NSManagedObjectContextDidSaveNotification object:[sharedInstance cdContainer].viewContext];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

- (void)onCoreDataStoreChanged: (NSNotification*) changedNotification {
    NSArray* updateObjects = [changedNotification.userInfo objectForKey:NSUpdatedObjectsKey];
    NSArray* insertedObjects = [changedNotification.userInfo objectForKey:NSInsertedObjectsKey];
    bool shouldUpdate = false;
    for (NSManagedObject* changedObj in updateObjects) {
        if ([changedObj isKindOfClass:[Event class]]) {
            shouldUpdate = true;
            break;
        }
    }

    if ([insertedObjects count] > 0) {
        shouldUpdate = true;
    }
    
    if (shouldUpdate) {
        [self attemptFullSyncorization:^{
            NSLog(@"Sync Complete");
        }];
    }
}

- (NSPersistentContainer *) cdContainer {
    return [(AppDelegate*)[[UIApplication sharedApplication]delegate] persistentContainer];
}

- (void) attemptFullSyncorization: (void (^)())complete {
    // Upload local records
    NSLog(@"Syncorization Triggered.");
    if (!self.isSyncing) {
        NSLog(@"Syncorization Began");
        self.isSyncing = true;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if ([[FreditAPI sharedInstance]isAuthenticated]) {
                // Update modified
                NSManagedObjectContext* ctx = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
                ctx.persistentStoreCoordinator = [self cdContainer].persistentStoreCoordinator;
                
                [ctx performBlockAndWait:^{
                    // Process Event Changes
                    NSEntityDescription* eventObjectDescription = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:ctx];
                    // Event Removal
                    NSFetchRequest* removedEvents = [[NSFetchRequest alloc]init];
                    removedEvents.entity = eventObjectDescription;
                    removedEvents.predicate = [NSPredicate predicateWithFormat:@"changed = -1"];
                    NSArray* removedEventList = [ctx executeFetchRequest:removedEvents error:nil];
                    int success = 0;
                    for (Event * event in removedEventList) {
                        if ([[FreditAPI sharedInstance]removeEvent:event.eventId]) {
                            success ++;
                        }
                        [ctx deleteObject:event];
                    }
                    NSLog(@"%i / %li of Event Deletion Succeed", success, [removedEventList count]);
                    
                    // Event Update
                    NSFetchRequest* modifiedEvents = [[NSFetchRequest alloc]init];
                    modifiedEvents.predicate = [NSPredicate predicateWithFormat:@"changed > 0"];
                    modifiedEvents.entity = eventObjectDescription;
                    NSArray* changedEventList = [ctx executeFetchRequest:modifiedEvents error:nil];
                    success = 0;
                    for (Event* event in changedEventList) {
                        [[FreditAPI sharedInstance]creditEvent:event];
                    }
                    NSLog(@"%i / %li of Event Update Succeed", success, [changedEventList count]);
                    [ctx save:nil];
                }];
                
                self.isSyncing = false;
            } else {
                // Release lock if sync failed
                self.isSyncing = false;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                complete();
            });
        });
    } else {
        complete();
    }
}

//- (void)

@end
