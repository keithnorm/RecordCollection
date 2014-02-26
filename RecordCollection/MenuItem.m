//
//  MenuItem.m
//  RecordCollection
//
//  Created by Keith Norman on 2/25/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import "MenuItem.h"

@interface MenuItem()

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation MenuItem

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    _textLabel = [[UILabel alloc] initWithFrame:self.bounds];
    [self addSubview:_textLabel];
    return self;
}

- (void)setText:(NSString *)text {
    _text = text;
    self.textLabel.text = text;
}

- (void)setContentInsets:(UIEdgeInsets)contentInsets {
    _contentInsets = contentInsets;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect textFrame = CGRectZero;
    textFrame.origin.y = self.contentInsets.top;
    textFrame.origin.x = self.contentInsets.left;
    self.textLabel.frame = textFrame;
    [self.textLabel sizeToFit];
}

@end
