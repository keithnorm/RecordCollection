//
//  ParallaxTableView.m
//  RecordCollection
//
//  Created by Keith Norman on 2/26/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import "ParallaxTableView.h"

@implementation ParallaxTableView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == self.tableHeaderView) {
        return nil;
    }
    return view;
}

@end
