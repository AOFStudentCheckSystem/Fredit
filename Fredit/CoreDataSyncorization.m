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
                NSManagedObjectContext* ctx = [[self cdContainer]viewContext];
                
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
                        NSString* str = [[FreditAPI sharedInstance]creditEvent:event];
                        if (str) {
                            success ++;
                            event.eventId = str;
                            NSLog(@"event ID: %@",event.eventId);
                        } else {
                            [ctx deleteObject:event];
                        }
                    }
                    [ctx save:nil];
                    NSLog(@"%i / %li of Event Update Succeed", success, [changedEventList count]);
                }];
                [self updateAllEventsFromServerInContext:ctx];
            }
            self.isSyncing = false;
            dispatch_sync(dispatch_get_main_queue(), ^{
                NSLog(@"Sync Complete");
                complete();
            });
        });
    } else {
        NSLog(@"A Conflict Sync detected. Aborting");
        complete();
    }
}

- (void) updateAllEventsFromServerInContext:(NSManagedObjectContext *)context {
    NSDictionary* data = [[FreditAPI sharedInstance] listAllEvents];
    if (data != nil) {
        NSMutableArray* eventIds = [[NSMutableArray alloc]init];
        //Add new Events
        [context performBlockAndWait:^{
            for (NSDictionary* dict in (NSArray *)[data objectForKey:@"content"]) {
                Event* event = [Event fetchOrCreateWithEventId:[dict objectForKey:@"eventId"] inManagedObjectContext: context];
                NSString* eventId = [dict objectForKey:@"eventId"];
                [eventIds addObject: eventId];
                //Update event obj
                if (![event.eventId isEqualToString:eventId]) {
                    [event setEventId:eventId];
                }
                NSDate* newDate = [NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"eventTime"] longValue] / 1000];
                if (![event.eventTime isEqualToDate:newDate]) {
                    [event setEventTime:[NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"eventTime"] longValue] / 1000]];
                }
                int newStatus = [[dict objectForKey:@"eventStatus"]intValue];
                if (event.eventStatus != newStatus) {
                    event.eventStatus = newStatus;
                }
                NSString* newName = [dict objectForKey:@"eventName"];
                if (![event.eventName isEqualToString:newName]) {
                    event.eventName = newName;
                }
                NSString* newDescription = [dict objectForKey:@"eventDescription"];
                if (![event.eventDescription isEqualToString:newDescription]) {
                    event.eventDescription = newDescription;
                }
                if (event.changed != 0) {
                    event.changed = 0;
                }
            }
            //Remove outdate events
            NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Event"];
            [request setPredicate:[NSPredicate predicateWithFormat:@"NOT (eventId in %@)" argumentArray:@[eventIds]]];
            NSArray* delArray = [context executeFetchRequest:request error:nil];
            for (NSManagedObject* obj in delArray) {
                [context deleteObject:obj];
                NSLog(@"Removing %@", [(Event*)obj eventName]);
            }
            //Save Data
            [context save:nil];
            [[[self cdContainer]viewContext]performBlockAndWait:^{
                [[[self cdContainer]viewContext]save:nil];
            }];
        }];
    }
}

//- (void)

@end
