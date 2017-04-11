//
//  Event+CoreDataClass.m
//  
//
//  Created by Codetector on 2017/4/11.
//
//

#import "Event+CoreDataClass.h"
#import "EventRecord+CoreDataClass.h"

@implementation Event

+(instancetype)fetchOrCreateWithEventId:(NSString *)eventId inManagedObjectContext:(NSManagedObjectContext *)context {
    
    // Fetch or Create root user data managed object
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setPredicate:[NSPredicate predicateWithFormat:@"eventId = %@" argumentArray:@[eventId]]];
    
    [request setEntity:entityDescription];
    
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];
    
    if (result == nil) {
        NSLog(@"fetch result = nil");
        // Handle the error here
    } else {
        if([result count] > 0) {
            return (Event *)[result objectAtIndex:0];
        } else {
            NSLog(@"create new MO");
            return (Event *)[NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:context];
        }
    }
    return nil;
}

@end
