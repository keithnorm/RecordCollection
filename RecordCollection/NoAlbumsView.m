//
//  NoAlbumsView.m
//  RecordCollection
//
//  Created by Keith Norman on 3/5/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import "NoAlbumsView.h"

@implementation NoAlbumsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
        label.text = @"cool";
        [self addSubview:label];
    }
    return self;
}

@end
