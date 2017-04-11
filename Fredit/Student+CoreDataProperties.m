//
//  Student+CoreDataProperties.m
//  
//
//  Created by Codetector on 2017/4/11.
//
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

@end
