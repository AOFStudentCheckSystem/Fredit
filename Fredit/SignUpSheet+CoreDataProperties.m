//
//  SignUpSheet+CoreDataProperties.m
//  
//
//  Created by Codetector on 2017/4/11.
//
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
