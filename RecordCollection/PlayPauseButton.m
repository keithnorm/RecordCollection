//
//  PlayPauseButton.m
//  RecordCollection
//
//  Created by Keith Norman on 2/24/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import "PlayPauseButton.h"
#import <CocoaLibSpotify/CocoaLibSpotify.h>

@interface PlayPauseButton()

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UIImage *playIcon;
@property (nonatomic, strong) UIImage *pauseIcon;

@end

@implementation PlayPauseButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _icon = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_icon];
//        _controlButtonColor = [UIColor blackColor];
        SPSession *session = [SPSession sharedSession];
        [session addObserver:self forKeyPath:@"playing" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    _playIcon = [self drawPlayIcon];
    _pauseIcon = [self drawPauseIcon];
}

- (UIImage *)drawPlayIcon {
    UIGraphicsBeginImageContext(self.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, self.bounds.size.width, self.bounds.size.height / 2);
    CGPathAddLineToPoint(path, NULL, 0, self.bounds.size.height);
    CGPathCloseSubpath(path);
    CGContextSetFillColorWithColor(context, self.controlButtonColor.CGColor);
    CGContextAddPath(context, path);
    CGContextFillPath(context);
    return UIGraphicsGetImageFromCurrentImageContext();
}

- (UIImage *)drawPauseIcon {
    UIGraphicsBeginImageContext(self.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, self.bounds.size.width / 3.0, 0);
    CGPathAddLineToPoint(path, NULL, self.bounds.size.width / 3.0, self.bounds.size.height);
    CGPathMoveToPoint(path, NULL, self.bounds.size.width * 2.0 / 3.0, 0);
    CGPathAddLineToPoint(path, NULL, self.bounds.size.width * 2.0 / 3.0, self.bounds.size.height);
    CGContextSetStrokeColorWithColor(context, self.controlButtonColor.CGColor);
    CGContextSetLineWidth(context, 4.0f);
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    return UIGraphicsGetImageFromCurrentImageContext();
}

- (void)setControlButtonColor:(UIColor *)controlButtonColor {
    _controlButtonColor = controlButtonColor;
    [self setNeedsDisplay];
}

- (void)setPlayState:(PlayerState)playState {
    _playState = playState;
    switch (_playState) {
        case PlayerStatePaused:
            self.icon.image = self.playIcon;
            break;
        
        case PlayerStatePlaying:
            self.icon.image = self.pauseIcon;
            break;
            
        default:
            break;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"playing"]) {
        if ([[change valueForKey:NSKeyValueChangeNewKey] boolValue]) {
            self.playState = PlayerStatePlaying;
        } else {
            self.playState = PlayerStatePaused;
        }
    }
}

- (void)dealloc {
    SPSession *session = [SPSession sharedSession];
    [session removeObserver:self forKeyPath:@"playing"];
}

@end
