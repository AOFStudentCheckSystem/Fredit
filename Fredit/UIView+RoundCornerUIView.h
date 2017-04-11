//
//  UIViewExtension.h
//  Fredit
//
//  Created by Codetector on 2017/4/10.
//  Copyright © 2017年 GuardianTechnologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface UIView (RoundCornerUIView)

- (void)createRoundCorner: (CGFloat) radius shadowRadius: (CGFloat) sRadius borderWidth: (CGFloat)width shadowOpacity: (float) shadowOpacity;
    
@end
