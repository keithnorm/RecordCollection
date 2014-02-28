//
//  UIView+CSS.h
//  RecordCollection
//
//  Created by Keith Norman on 2/25/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSSBorder.h"

@interface CSSDropshadow : NSObject

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CGFloat xOffset;
@property (nonatomic, assign) CGFloat yOffset;
@property (nonatomic, assign) CGFloat blur;

@end

@interface CSSBorderRadius : NSObject

@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) UIRectCorner corners;

- (instancetype)initWithRadius:(CGFloat)radius;

@end


@interface UIView (CSS)

@property (nonatomic, strong) CSSBorder *border UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) CSSBorder *borderTop UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) CSSBorder *borderBottom UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) CSSDropshadow *dropShadow UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) CSSBorderRadius *borderRadius UI_APPEARANCE_SELECTOR;

@end
