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
#import "Reachability.h"
#import "Student+CoreDataClass.h";

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
        [[NSNotificationCenter defaultCenter]addObserver:sharedInstance selector:@selector(networkStatusChange:) name:kReachabilityChangedNotification object:nil];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

- (int)currentNetworkStatus {
    return ((AppDelegate*)[[UIApplication sharedApplication] delegate]).hostReachability.currentReachabilityStatus;
}

- (void)networkStatusChange: (NSNotification*)n {
    if ([n.object isKindOfClass:[Reachability class]]) {
        if (((Reachability*)n.object).currentReachabilityStatus > 0 ) {
            [self attemptFullSyncorization:nil];
        }
    }
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
        [self attemptFullSyncorization:nil];
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
            NSManagedObjectContext* ctx = [[self cdContainer]viewContext];
            if ([self currentNetworkStatus] > 0 && [[FreditAPI sharedInstance]isAuthenticated]) {
                // Update modified
                [ctx performBlockAndWait:^{
                    // Process Changes
                    NSEntityDescription* eventObjectDescription = [NSEntityDescription entityForName:@"TrackableObject" inManagedObjectContext:ctx];
                    // Removal
                    NSFetchRequest* removedEvents = [[NSFetchRequest alloc]init];
                    removedEvents.entity = eventObjectDescription;
                    removedEvents.predicate = [NSPredicate predicateWithFormat:@"changed = -1"];
                    NSArray* removedEventList = [ctx executeFetchRequest:removedEvents error:nil];
                    int success = 0;
                    for (TrackableObject * trackable in removedEventList) {
                        if ([trackable isKindOfClass:[Event class]]) {
                            if ([[FreditAPI sharedInstance]removeEvent:((Event*)trackable).eventId]) {
                                success ++;
                            }
                            [ctx deleteObject:trackable];
                        }
                    }
                    NSLog(@"%i / %ld of Trackable Deletion Succeed", success, (unsigned long)[removedEventList count]);
                    
                    // Event Update
                    NSFetchRequest* modifiedEvents = [[NSFetchRequest alloc]init];
                    modifiedEvents.predicate = [NSPredicate predicateWithFormat:@"changed > 0"];
                    modifiedEvents.entity = eventObjectDescription;
                    NSArray* changedEventList = [ctx executeFetchRequest:modifiedEvents error:nil];
                    success = 0;
                    for (TrackableObject* trackable in changedEventList) {
                        if ([trackable isKindOfClass:[Event class]]) {
                            NSString* str = [[FreditAPI sharedInstance]creditEvent:(Event*)trackable];
                            if (str) {
                                success ++;
                                ((Event*)trackable).eventId = str;
                            } else {
                                [ctx deleteObject:trackable];
                            }
                        }
                    }
                    [ctx save:nil];
                    NSLog(@"%i / %ld of Trackable Update Succeed", success, (unsigned long) [changedEventList count]);
                }];
            }
            [self updateAllEventsFromServerInContext: ctx];
            self.isSyncing = false;
            dispatch_sync(dispatch_get_main_queue(), ^{
                NSLog(@"Sync Complete");
                if (complete)
                    complete();
            });
        });
    } else {
        NSLog(@"A Conflict Sync detected. Aborting");
        if (complete)
            complete();
    }
}

- (void) syncorizeAllStudents {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self saveAllStudentInContext:[[self cdContainer] viewContext]];
    });
}

- (void) saveAllStudentInContext: (NSManagedObjectContext *)context {
    NSArray* students = [[FreditAPI sharedInstance]fetchAllStudent];
    NSMutableArray* studentIds = [[NSMutableArray alloc]init];
    [context performBlockAndWait:^{
        for (NSDictionary* student in students) {
            NSString* studentId =[student objectForKey:@"idNumber"];
            [studentIds addObject:studentId];
            Student* stu = [Student fetchOrCreateWithStudentId:studentId inManagedObjectContext:[[self cdContainer]viewContext]];
            if (![stu.firstName isEqualToString:[student objectForKey:@"firstName"]]) {
                stu.firstName = [student objectForKey:@"firstName"];
            }
            if (![stu.cardSecret isEqualToString:[student objectForKey:@"cardSecret"]]) {
                if ([student objectForKey:@"cardSecret"] != [NSNull null]){
                    stu.cardSecret = [student objectForKey:@"cardSecret"];
                }
            }
            if (![stu.idNumber isEqualToString:[student objectForKey:@"idNumber"]]) {
                if ([student objectForKey:@"idNumber"] != [NSNull null]){
                    stu.idNumber = [student objectForKey:@"idNumber"];
                }
            }
            if (![stu.lastName isEqualToString:[student objectForKey:@"lastName"]]) {
                stu.lastName = [student objectForKey:@"lastName"];
            }
            if (![stu.preferredName isEqualToString:[student objectForKey:@"preferredName"]]) {
                if ([student objectForKey:@"preferredName"] != [NSNull null]){
                    stu.preferredName = [student objectForKey:@"preferredName"];
                }
            }
            if (stu.changed != 0) {
                stu.changed = 0;
            }
        }
        // Removing
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Student"];
        [request setPredicate:[NSPredicate predicateWithFormat:@"NOT (idNumber in %@)" argumentArray:@[studentIds]]];
        NSArray* delArray = [context executeFetchRequest:request error:nil];
        for (NSManagedObject* obj in delArray) {
            [context deleteObject:obj];
        }
        [context save:nil];
        [[[self cdContainer]viewContext]performBlockAndWait:^{
            [[[self cdContainer]viewContext]refreshAllObjects];
            [[[self cdContainer]viewContext]save:nil];
        }];
    }];
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
            }
            //Save Data
            [context save:nil];
            [[[self cdContainer]viewContext]performBlockAndWait:^{
                [[[self cdContainer]viewContext]refreshAllObjects];
                [[[self cdContainer]viewContext]save:nil];
            }];
        }];
    }
}

//- (void)

@end
