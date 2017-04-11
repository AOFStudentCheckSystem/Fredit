//
//  FreditAPI.h
//  Fredit
//
//  Created by Codetector on 2017/4/11.
//  Copyright © 2017年 GuardianTechnologies. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FreditAPI : NSObject

extern const NSString* rootURL;

+ (instancetype) sharedInstance;

- (NSDictionary*) listAllEvents;

@end
