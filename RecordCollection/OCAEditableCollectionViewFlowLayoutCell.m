//
//  OCAEditableCollectionViewFlowLayoutCell.m
//  KOResume
//
//  Created by Kevin O'Mara on 10/28/13.
//  Copyright (c) 2013-2014 O'Mara Consulting Associates. All rights reserved.
//

#import "OCAEditableCollectionViewFlowLayoutCell.h"
#import "OCAEditableLayoutAttributes.h"
#import "OCAEditableCollectionViewFlowLayout.h"

#define MARGIN 20

@implementation OCAEditableCellDeleteButton

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    [self setNeedsDisplay];
}

- (void)setStrokeColor:(UIColor *)strokeColor {
    _strokeColor = strokeColor;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGRect buttonFrame  = rect;
    UIGraphicsBeginImageContext(buttonFrame.size);
    
    CGContextRef context    = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGFloat sz          = MIN(buttonFrame.size.width, buttonFrame.size.height);
    UIBezierPath *path  = [UIBezierPath bezierPathWithArcCenter: CGPointMake(buttonFrame.size.width/2, buttonFrame.size.height/2)
                                                         radius: sz/2-2
                                                     startAngle: 0
                                                       endAngle: M_PI * 2
                                                      clockwise: YES];
    [path moveToPoint: CGPointMake(MARGIN, MARGIN)];
    [path addLineToPoint: CGPointMake(sz-MARGIN, sz-MARGIN)];
    [path moveToPoint: CGPointMake(MARGIN, sz-MARGIN)];
    [path addLineToPoint: CGPointMake(sz-MARGIN, MARGIN)];
    [self.backgroundColor setFill];
    [self.strokeColor setStroke];
    [path setLineWidth: 2.0];
    [path fill];
    [path stroke];
    
    UIImage *deleteButtonImg = UIGraphicsGetImageFromCurrentImageContext();
    CGContextRestoreGState(context);
    UIGraphicsEndImageContext();
    // Set the image for the delete button
    [self setImage:deleteButtonImg
                       forState:UIControlStateNormal];
}

@end

@interface OCAEditableCollectionViewFlowLayoutCell ()

@end

@implementation OCAEditableCollectionViewFlowLayoutCell


static UIImage *deleteButtonImg;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        _backgroundColor = self.tintColor;
//        _borderColor = [UIColor whiteColor];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
//        _backgroundColor = self.tintColor;
//        _borderColor = [UIColor whiteColor];
    }
    return self;
}

//----------------------------------------------------------------------------------------------------------
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.clipsToBounds = NO;
    self.deleteButton = [[OCAEditableCellDeleteButton alloc] initWithFrame:CGRectMake(-10, -10, 64, 64)];
    // ...and the handler for button presses
    [self.deleteButton addTarget: self
                          action: @selector(didPressDeleteButton)
                forControlEvents: UIControlEventTouchUpInside];
    // ...make if hidden initially
    [self.deleteButton setHidden: YES];
    // ...and add it to the cell's contentView
    [self.contentView addSubview: self.deleteButton];
}


//----------------------------------------------------------------------------------------------------------
- (void)startQuivering
{
    
    CABasicAnimation *quiverAnim = [CABasicAnimation animationWithKeyPath: @"transform.rotation"];
    
    float startAngle    = (-2) * M_PI/180.0;
    float stopAngle     = -startAngle;
    
    quiverAnim.fromValue    = [NSNumber numberWithFloat:startAngle];
    quiverAnim.toValue      = [NSNumber numberWithFloat:2 * stopAngle];
    quiverAnim.autoreverses = YES;
    quiverAnim.duration     = 0.15;
    quiverAnim.repeatCount  = HUGE_VALF;
    float timeOffset        = (float)(arc4random() % 100)/100 - 0.50;
    quiverAnim.timeOffset   = timeOffset;
    CALayer *layer          = self.layer;
    
    [layer addAnimation: quiverAnim
                 forKey: @"quivering"];
}


//----------------------------------------------------------------------------------------------------------
- (void)stopQuivering
{
    
    CALayer *layer = self.layer;
    [layer removeAnimationForKey:@"quivering"];
}

//----------------------------------------------------------------------------------------------------------
- (void)applyLayoutAttributes:(OCAEditableLayoutAttributes *)layoutAttributes
{
    
    if ([layoutAttributes isKindOfClass:[OCAEditableLayoutAttributes class]]) {
        // TODO - see if we can use UIKitDynamics for the quivering behavior
        if (layoutAttributes.isDeleteButtonHidden) {
            [self.deleteButton setHidden:YES];
            [self stopQuivering];
        } else {
            [self.deleteButton setHidden:NO];
            [self startQuivering];
        }
    }
}

//----------------------------------------------------------------------------------------------------------
- (void)didPressDeleteButton
{
    assert(self.deleteDelegate);
    
    [_deleteDelegate deleteCell: self];
}

@end
