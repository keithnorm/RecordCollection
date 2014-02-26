//
//  UIImage+Gradient.m
//  RecordCollection
//
//  Created by Keith Norman on 2/25/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import "UIImage+Gradient.h"

@implementation UIImage (Gradient)

+ (instancetype)gradientWithColors:(NSArray *)colors height:(CGFloat)height {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, 1, height);
    gradient.colors = colors;
    UIGraphicsBeginImageContext(gradient.bounds.size);
    
    [gradient renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *gradientImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return gradientImage;
}

@end
