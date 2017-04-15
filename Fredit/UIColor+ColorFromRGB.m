//
//  UIColor+ColorFromRGB.m
//  Fredit
//
//  Created by Codetector on 2017/4/14.
//  Copyright © 2017年 GuardianTechnologies. All rights reserved.
//

#import "UIColor+ColorFromRGB.h"

@implementation UIColor (ColorFromRGB)

+ (UIColor *)colorWithRGB: (int) rgb {
    return [UIColor colorWithRed:((rgb & 0xFF0000) >> 16) / 255.0f green: ((rgb & 0x00FF00) >> 8) / 255.0f blue:(rgb & 0x0000FF) / 255.0f alpha:1];
}

@end
