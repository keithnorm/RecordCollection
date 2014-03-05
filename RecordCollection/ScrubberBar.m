//
//  ScrubberBar.m
//  RecordCollection
//
//  Created by Keith Norman on 3/4/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import "ScrubberBar.h"
#import "ScrubberBarProgressBar.h"
#import "UIView+Event.h"

@interface ScrubberBar()

@property (nonatomic, strong) IBOutlet ScrubberBarProgressBar *progressBar;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *progressBarWidth;


@end

@implementation ScrubberBar

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _min = 0;
        _max = 100;
        _value = 0;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        [self addGestureRecognizer:tapGestureRecognizer];
    }
    return self;
}

- (void)setValue:(CGFloat)value {
    _value = value;
    self.progressBarWidth.constant = self.bounds.size.width * value / self.max;
}

- (void)onTap:(UITapGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:self];
    [self fireEvent:@"userDidSeek" withObject:@((point.x / self.bounds.size.width) * self.max)];
}

@end
