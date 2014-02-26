//
//  UIView+StyleClass.m
//  RecordCollection
//
//  Created by Keith Norman on 2/25/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import "UIView+StyleClass.h"
#import "Theme.h"
#import <objc/runtime.h>

@implementation UIView (StyleClass)

@dynamic styleClass;

- (void)setStyleClass:(NSString *)styleClass {
    NSString *selectorName = [@"style" stringByAppendingString:[NSString stringWithFormat:@"%@%@:", [[styleClass substringToIndex:1] uppercaseString], [styleClass substringFromIndex:1]]];
    SEL sel = NSSelectorFromString(selectorName);
    if (class_getClassMethod([Theme class], sel) != NULL) {
        [Theme performSelector:sel withObject:self];
    }
}

@end
