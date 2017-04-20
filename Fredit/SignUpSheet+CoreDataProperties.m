//
//  SignUpSheet+CoreDataProperties.m
//  Fredit
//
//  Created by Codetector on 2017/4/20.
//  Copyright © 2017年 GuardianTechnologies. All rights reserved.
//

#import "SignUpSheet+CoreDataProperties.h"

@implementation SignUpSheet (CoreDataProperties)

+ (NSFetchRequest<SignUpSheet *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"SignUpSheet"];
}

@dynamic id;
@dynamic name;
@dynamic status;
@dynamic eventGroups;

@end
