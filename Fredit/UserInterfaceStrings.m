//
//  UserInterfaceStrings.m
//  Fredit
//
//  Created by Codetector on 2017/4/20.
//  Copyright © 2017年 GuardianTechnologies. All rights reserved.
//

#import "UserInterfaceStrings.h"
#import "UIColor+ColorFromRGB.h"
#import <UIKit/UIKit.h>

@implementation UserInterfaceStrings

+ (NSAttributedString *) localizedStringForEventStatus: (int) status {
    NSAttributedString* string;
    switch (status) {
        case 0:
            string = [[NSAttributedString alloc]initWithString:NSLocalizedString(@"EVENT_STATUS_FUTURE", @"Future Event") attributes:@{NSForegroundColorAttributeName : [UIColor colorWithRGB:0x007aff]}];
            break;
        case 1:
            string = [[NSAttributedString alloc]initWithString:NSLocalizedString(@"EVENT_STATUS_BOARDING", @"Future Event") attributes:@{NSForegroundColorAttributeName : [UIColor colorWithRGB:0xffcc00]}];
            break;
        case 2:
            string = [[NSAttributedString alloc]initWithString:NSLocalizedString(@"EVENT_STATUS_COMPLETE", @"Future Event") attributes:@{NSForegroundColorAttributeName : [UIColor colorWithRGB:0x4cd964]}];
            break;
        default:
            string = [[NSAttributedString alloc]initWithString:NSLocalizedString(@"EVENT_STATUS_UNKNOWN", @"Future Event") attributes:@{NSForegroundColorAttributeName : [UIColor darkTextColor]}];
            break;
    }
    return string;
}

@end
