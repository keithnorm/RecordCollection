//
//  NextButton.m
//  RecordCollection
//
//  Created by Keith Norman on 3/4/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import "NextButton.h"

static const CGFloat kVerticalPadding = 18.0f;
static const CGFloat kHorizontalPadding = 16.0f;

@implementation NextButton

- (void)drawRect:(CGRect)rect {
    CGRect rectWithPadding = CGRectOffset(rect, kHorizontalPadding / 2.0f, 0);
    rectWithPadding.size.width -= kHorizontalPadding;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, rectWithPadding.origin.x, kVerticalPadding);
    CGPathAddLineToPoint(path, NULL, rectWithPadding.origin.x + rectWithPadding.size.width / 2 - 1, rectWithPadding.size.height / 2);
    CGPathAddLineToPoint(path, NULL, rectWithPadding.origin.x, rectWithPadding.size.height - kVerticalPadding);
    CGPathCloseSubpath(path);
    CGContextSetFillColorWithColor(context, self.tintColor.CGColor);
    
    CGPathMoveToPoint(path, NULL, rectWithPadding.origin.x + rectWithPadding.size.width / 2 + 1, kVerticalPadding);
    CGPathAddLineToPoint(path, NULL, rectWithPadding.origin.x + rectWithPadding.size.width, rectWithPadding.size.height / 2);
    CGPathAddLineToPoint(path, NULL, rectWithPadding.origin.x + rectWithPadding.size.width / 2 + 1, rectWithPadding.size.height - kVerticalPadding);
    CGPathCloseSubpath(path);
    
    CGContextAddPath(context, path);
    CGContextFillPath(context);
}

@end
