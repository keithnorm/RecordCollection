//
//  NextButton.m
//  RecordCollection
//
//  Created by Keith Norman on 3/4/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import "NextButton.h"

@implementation NextButton

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, rect.size.width / 2 - 1, rect.size.height / 2);
    CGPathAddLineToPoint(path, NULL, 0, rect.size.height);
    CGPathCloseSubpath(path);
    CGContextSetFillColorWithColor(context, self.tintColor.CGColor);
    
    CGPathMoveToPoint(path, NULL, rect.size.width / 2 + 1, 0);
    CGPathAddLineToPoint(path, NULL, rect.size.width, rect.size.height / 2);
    CGPathAddLineToPoint(path, NULL, rect.size.width / 2 + 1, rect.size.height);
    CGPathCloseSubpath(path);
    
    CGContextAddPath(context, path);
    CGContextFillPath(context);
}

@end
