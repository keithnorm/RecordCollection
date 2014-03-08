//
//  UIFont+Scale.m
//  RecordCollection
//
//  Created by Keith Norman on 3/7/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import "UIFont+Scale.h"

@implementation UIFont (Scale)

+ (UIFont *)preferredFontForTextStyle:(NSString *)style scale:(CGFloat)scaleFactor {
    UIFontDescriptor *descriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:style];
    CGFloat pointSize = descriptor.pointSize * scaleFactor;
    UIFont *font = [UIFont fontWithDescriptor:descriptor size:pointSize];
    return font;
}

@end
