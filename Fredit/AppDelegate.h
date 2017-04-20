//
//  AppDelegate.h
//  Fredit
//
//  Created by Codetector on 2017/4/10.
//  Copyright © 2017年 GuardianTechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Reachability.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic, readonly) Reachability* hostReachability;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

