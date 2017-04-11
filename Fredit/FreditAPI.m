//
//  FreditAPI.m
//  Fredit
//
//  Created by Codetector on 2017/4/11.
//  Copyright © 2017年 GuardianTechnologies. All rights reserved.
//

#import "FreditAPI.h"
#import <UNIRest.h>
@interface FreditAPI()

@property (strong, nonatomic) NSString* userAuthorizationToken;

@end

@implementation FreditAPI

NSString* rootURL = @"https://check.guardiantech.com.cn/";

+ (instancetype)sharedInstance
{
    static FreditAPI *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FreditAPI alloc] init];
        // Do any other initialisation stuff here
        
        NSString* auth = [[NSUserDefaults standardUserDefaults]objectForKey:@"AuthorizationToken"];
        if (auth != nil && ![auth isEqualToString:@""]) {
            sharedInstance.userAuthorizationToken = false;
        } else {
            sharedInstance.userAuthorizationToken = auth;
        }
    });
    return sharedInstance;
}

- (NSDictionary*) getHeaders {
    NSMutableDictionary* headersDict = [[NSMutableDictionary alloc] init];
    
    [headersDict setObject:@"application/json" forKey:@"accept"];
    
    if (![self.userAuthorizationToken isEqualToString:@""]) {
        [headersDict setObject:self.userAuthorizationToken forKey:@"Authroization"];
    }
    
    return headersDict;
}

- (NSDictionary*) listAllEvents {
    UNIHTTPJsonResponse* json = [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
        simpleRequest.url = [rootURL stringByAppendingString:@"event/list"];
        simpleRequest.headers = [self getHeaders];
    }]asJson];
    
    return [[json body]JSONObject];
}

@end
