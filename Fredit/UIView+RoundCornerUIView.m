//
//  UIViewExtension.m
//  Fredit
//
//  Created by Codetector on 2017/4/10.
//  Copyright © 2017年 GuardianTechnologies. All rights reserved.
//

#import "UIView+RoundCornerUIView.h"

@implementation UIView (RoundCornerUIView)
    
-(void)createRoundCorner: (CGFloat) radius shadowRadius: (CGFloat) sRadius borderWidth: (CGFloat)width shadowOpacity: (float) shadowOpacity{
    CALayer* layer = self.layer;
    
    layer.masksToBounds = false;
    layer.shadowColor = [[UIColor lightGrayColor]CGColor];
    layer.shadowRadius = sRadius;
    layer.shadowOpacity = shadowOpacity;
    layer.shadowOffset = CGSizeMake(1, 1);
    layer.shouldRasterize = false;
    layer.cornerRadius = radius;
    layer.borderColor = [[UIColor whiteColor]CGColor];
    layer.borderWidth = width;
    layer.shadowPath = [[UIBezierPath bezierPathWithRect:self.bounds]CGPath];
}
@end
