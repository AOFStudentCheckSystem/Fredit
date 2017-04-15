//
//  NSDate+Rounding.m
//  Fredit
//
//  Created by Codetector on 2017/4/15.
//  Copyright © 2017年 GuardianTechnologies. All rights reserved.
//

#import "NSDate+Rounding.h"

@implementation NSDate (Rounding)

- (NSDate *)roundDateToNearestFifteenMinutes
{
    NSTimeInterval seconds = ceil([self timeIntervalSinceReferenceDate]/900.0)*900.0;
    return [NSDate dateWithTimeIntervalSinceReferenceDate:seconds];
}

@end
