//
//  UILabel+AppearanceFix.m
//  RecordCollection
//
//  Created by Keith Norman on 2/25/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import "UILabel+AppearanceFix.h"

@implementation UILabel (AppearanceFix)

- (void)setTextAttributes:(NSDictionary *)numberTextAttributes; {
    UIFont *font = [numberTextAttributes objectForKey:NSFontAttributeName];
    if (font) {
        self.font = font;
    }
    UIColor *textColor = [numberTextAttributes objectForKey:NSForegroundColorAttributeName];
    if (textColor) {
        self.textColor = textColor;
    }
    UIColor *textShadowColor = [numberTextAttributes objectForKey:NSShadowAttributeName];
    if (textShadowColor) {
        self.shadowColor = textShadowColor;
    }
}

@end
