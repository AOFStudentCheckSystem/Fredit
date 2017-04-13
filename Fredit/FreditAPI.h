//
//  FreditAPI.h
//  Fredit
//
//  Created by Codetector on 2017/4/11.
//  Copyright © 2017年 GuardianTechnologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FreditAPI : NSObject

@property (strong, nonatomic, readonly) NSString* userAuthorizationToken;

extern const NSString* rootURL;

+ (instancetype) sharedInstance;

- (NSDictionary*) listAllEvents;

- (BOOL) loginWithUsername: (NSString *) username andPassword: (NSString*)password;

- (BOOL) removeEvent: (NSString *) eventId;

- (void) signOut;

@end
