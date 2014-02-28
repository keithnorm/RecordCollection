//
//  UIView+CSS.m
//  RecordCollection
//
//  Created by Keith Norman on 2/25/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import "UIView+CSS.h"
#import <objc/runtime.h>

@implementation CSSDropshadow

- (instancetype)init {
    self = [super init];
    if (self) {
        _blur = 1.5f;
        _xOffset = 0.0f;
        _yOffset = -3.0f;
        _color = [UIColor blackColor];
    }
    return self;
}

@end

@implementation CSSBorderRadius

- (instancetype)init {
    self = [super init];
    if (self) {
        _radius = 1.0f;
        _corners = UIRectCornerAllCorners;
    }
    return self;
}

- (instancetype)initWithRadius:(CGFloat)radius {
    self = [self init];
    if (self) {
        _radius = radius;
    }
    return self;
}

@end

@implementation UIView (CSS)

@dynamic border, borderRadius, dropShadow, borderBottom, borderTop;

- (void)setBorderBottom:(CSSBorder *)borderBottom {
    borderBottom.sides = CSSBorderSideBottom;
    [self setBorder:borderBottom];
}

- (void)setBorderTop:(CSSBorder *)borderTop {
    borderTop.sides = CSSBorderSideTop;
    [self setBorder:borderTop];
}

- (void)setBorder:(CSSBorder *)border {
    if (border.sides == CSSBorderSideAll) {
        self.layer.borderColor = border.color.CGColor;
        self.layer.borderWidth = border.width;
        return;
    }
    if (border.sides & CSSBorderSideTop) {
        CALayer *layer = [[CALayer alloc] init];
        layer.frame = CGRectMake(0, 0, self.bounds.size.width, border.width);
        layer.backgroundColor = border.color.CGColor;
        [self.layer insertSublayer:layer atIndex:0];
    }
    if (border.sides & CSSBorderSideRight) {
        CALayer *layer = [[CALayer alloc] init];
        layer.frame = CGRectMake(self.bounds.size.width - border.width, 0, border.width, self.bounds.size.height);
        layer.backgroundColor = border.color.CGColor;
        [self.layer insertSublayer:layer atIndex:0];
    }
    
    if (border.sides & CSSBorderSideBottom) {
        CALayer *layer = [[CALayer alloc] init];
        layer.frame = CGRectMake(0, self.bounds.size.height - border.width, self.bounds.size.width, border.width);
        layer.backgroundColor = border.color.CGColor;
        [self.layer insertSublayer:layer atIndex:0];
    }
    
    if (border.sides & CSSBorderSideLeft) {
        CALayer *layer = [[CALayer alloc] init];
        layer.frame = CGRectMake(0, 0, border.width, self.bounds.size.height);
        layer.backgroundColor = border.color.CGColor;
        [self.layer insertSublayer:layer atIndex:0];
    }
}

- (void)setDropShadow:(CSSDropshadow *)dropShadow {
    self.layer.shadowColor = dropShadow.color.CGColor;
    self.layer.masksToBounds = NO;
    self.layer.shadowOffset = CGSizeMake(dropShadow.xOffset, dropShadow.yOffset);
    self.layer.shadowRadius = dropShadow.blur;
    self.layer.shadowOpacity = 0.5;
}

- (void)setBorderRadius:(CSSBorderRadius *)borderRadius {
    [self addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew context:NULL];
    UIBezierPath *maskPath;
        maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:borderRadius.corners cornerRadii:CGSizeMake(borderRadius.radius, borderRadius.radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    objc_setAssociatedObject(self, @selector(borderRadius), borderRadius, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.layer.mask = maskLayer;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"bounds"]) {
        CSSBorderRadius *borderRadius = objc_getAssociatedObject(self, @selector(borderRadius));
        if (borderRadius) {
            [object setBorderRadius:borderRadius];
        }
    }
}

- (void)dealloc {

}

@end
