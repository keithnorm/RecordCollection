//
//  OpenDrawerBtn.m
//  RecordCollection
//
//  Created by Keith Norman on 3/19/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import "OpenDrawerBtn.h"
#import "UIView+Event.h"

@implementation OpenDrawerBtn

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _lineColor = [UIColor orangeColor];
        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleDrawer)];
        [self addGestureRecognizer:gestureRecognizer];
    }
    return self;
}

- (void)toggleDrawer {
    [self fireEvent:@"toggleDrawer" withObject:nil];
}

- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    CGContextSetLineWidth(ctx, 3.0f);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(ctx, self.lineColor.CGColor);
    CGPathMoveToPoint(path, NULL, 2, 2);
    CGPathAddLineToPoint(path, NULL, rect.size.width - 2, 2);
    CGPathMoveToPoint(path, NULL, 2, ceilf(rect.size.width / 3));
    CGPathAddLineToPoint(path, NULL, rect.size.width - 2, ceilf(rect.size.width / 3));
    CGPathMoveToPoint(path, NULL, 2, rect.size.height - 2);
    CGPathAddLineToPoint(path, NULL, rect.size.width - 2, rect.size.height - 2);
    CGContextAddPath(ctx, path);
    CGContextStrokePath(ctx);
}

@end
