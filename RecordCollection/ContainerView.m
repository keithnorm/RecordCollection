//
//  ContainerView.m
//  RecordCollection
//
//  Created by Keith Norman on 3/5/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import "ContainerView.h"

@implementation ContainerView

- (CGSize)intrinsicContentSize {
    CGSize size = CGSizeMake(0, 0);
    
    for (UIView *view in self.subviews) {
        CGSize subviewSize = [view intrinsicContentSize];
        if (subviewSize.width > size.width) {
            size.width = subviewSize.width;
        }
        if (subviewSize.height + view.frame.origin.y > size.height) {
            size.height = subviewSize.height + view.frame.origin.y;
        }
    }
    return size;
}

@end
