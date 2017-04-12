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

@property (strong, nonatomic, readwrite) NSString* userAuthorizationToken;

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
        if (auth == nil || [auth isEqualToString:@""]) {
            sharedInstance.userAuthorizationToken = @"";
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
    [UNIRest timeout:15];
    UNIHTTPJsonResponse* json = [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
        simpleRequest.url = [rootURL stringByAppendingString:@"event/list"];
        simpleRequest.headers = [self getHeaders];
    }]asJson];
    
    return [[json body]JSONObject];
}

- (BOOL) loginWithUsername: (NSString*) username andPassword: (NSString*)password {
    [UNIRest timeout: 10];
    UNIHTTPJsonResponse* json = [[UNIRest post:^(UNISimpleRequest *simpleRequest) {
        [simpleRequest setUrl:[rootURL stringByAppendingString:@"auth/auth"]];
        [simpleRequest setHeaders:[self getHeaders]];
        [simpleRequest setParameters:@{@"email": username, @"password": password}];
    }]asJson];
    NSLog(@"Network => %li", json.code);
    if (json.code == 200) {
        NSString* token = [json.body.object objectForKey: @"token"];
        [[NSUserDefaults standardUserDefaults]setObject:token forKey:@"AuthorizationToken"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        self.userAuthorizationToken = token;
        NSLog(@"%@", token);
        return true;
    } else {
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"AuthorizationToken"];
        self.userAuthorizationToken = @"";
        return false;
    }
}

@end
