//
//  FreditAPI.h
//  Fredit
//
//  Created by Codetector on 2017/4/11.
//  Copyright © 2017年 GuardianTechnologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event+CoreDataClass.h"

@interface FreditAPI : NSObject

@property (strong, nonatomic, readonly) NSString* userAuthorizationToken;

extern const NSString* rootURL;
+ (BOOL) isDeviceOnline;
+ (instancetype) sharedInstance;

- (NSDictionary*) listAllEvents;

- (BOOL) loginWithUsername: (NSString *) username andPassword: (NSString*)password;

- (BOOL) removeEvent: (NSString *) eventId;

- (void) signOut;

- (NSString *) creditEvent: (Event*) event;

- (BOOL) creditEventWithId: (NSString*) eventId andEventName: (NSString*) name andTime: (NSDate*) time andDescription: (NSString*) description;

- (BOOL)sendMailforEvent: (Event*)evnt toAddress: (NSString*) str;

- (BOOL) isAuthenticated;
- (NSDictionary*) fetchRecordsForEvent: (Event*) event;
- (NSArray *) fetchAllStudent;
@end
