//
//  FreditDataAccessObject.m
//  Fredit
//
//  Created by Codetector on 2017/4/15.
//  Copyright © 2017年 GuardianTechnologies. All rights reserved.
//

#import "FreditDataAccessObject.h"
#import "FreditAPI.h"
#import "Event+CoreDataClass.h"
#import <SVProgressHUD.h>

@implementation FreditDataAccessObject

+ (void) updateAllEventsFromServerInContext:(NSManagedObjectContext *)context {
    NSDictionary* data = [[FreditAPI sharedInstance]listAllEvents];
    if (data != nil) {
        NSMutableArray* eventIds = [[NSMutableArray alloc]init];
        //Add new Events
        for (NSDictionary* dict in (NSArray *)[data objectForKey:@"content"]) {
            Event* event = [Event fetchOrCreateWithEventId:[dict objectForKey:@"eventId"] inManagedObjectContext: context];
            NSString* eventId = [dict objectForKey:@"eventId"];
            [eventIds addObject: eventId];
            [event setEventId:eventId];
            [event setEventTime:[NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"eventTime"] longValue] / 1000]];
            event.eventStatus = [[dict objectForKey:@"eventStatus"]intValue];
            event.eventName = [dict objectForKey:@"eventName"];
            event.eventDescription = [dict objectForKey:@"eventDescription"];
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
        //                [context save:nil];
    } else {
        [SVProgressHUD showErrorWithStatus:@"Network Error!"];
    }
}

@end
