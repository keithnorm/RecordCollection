//
//  CSSBorder.m
//  RecordCollection
//
//  Created by Keith Norman on 2/25/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import "CSSBorder.h"

@implementation CSSBorder

- (id)init {
    self = [super init];
    if (self) {
        _width = 1.0f;
        _sides = CSSBorderSideAll;
        _color = [UIColor blackColor];
    }
    return self;
}

@end
