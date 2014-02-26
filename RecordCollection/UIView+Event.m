//
//  UIView+Event.m
//  RecordCollection
//
//  Created by Keith Norman on 2/24/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import "UIView+Event.h"

@implementation UIView (Event)

- (void)fireEvent:(NSString *)eventName withObject:(id)obj {
    UIResponder *nextResponder = self.nextResponder;
    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@:", eventName]);
    while (nextResponder) {
        if ([nextResponder respondsToSelector:selector]) {
            NSMethodSignature *signature  = [nextResponder methodSignatureForSelector:selector];
            NSInvocation      *invocation = [NSInvocation invocationWithMethodSignature:signature];
            invocation.selector = selector;
            invocation.target = nextResponder;
            [invocation setArgument:&obj atIndex:2];
            [invocation invoke];
        }
        nextResponder = nextResponder.nextResponder;
    }
}

@end
