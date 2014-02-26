//
//  CSSBorder.h
//  RecordCollection
//
//  Created by Keith Norman on 2/25/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, CSSBorderSide) {
    CSSBorderNone      = 0,
    CSSBorderSideTop   = 1 << 0,
    CSSBorderSideRight = 1 << 1,
    CSSBorderSideBottom  = 1 << 2,
    CSSBorderSideLeft    = 1 << 3,
    CSSBorderSideAll    = 1 << 4
};

@interface CSSBorder : NSObject

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) NSUInteger sides;

@end
