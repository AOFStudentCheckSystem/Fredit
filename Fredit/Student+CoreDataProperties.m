//
//  Student+CoreDataProperties.m
//  Fredit
//
//  Created by Codetector on 2017/4/22.
//  Copyright © 2017年 GuardianTechnologies. All rights reserved.
//

#import "Student+CoreDataProperties.h"

@implementation Student (CoreDataProperties)

+ (NSFetchRequest<Student *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Student"];
}

@dynamic cardSecret;
@dynamic firstName;
@dynamic idNumber;
@dynamic lastName;
@dynamic preferredName;
@dynamic records;

@end
