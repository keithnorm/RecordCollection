//
//  SearchHeader.m
//  RecordCollection
//
//  Created by Keith Norman on 2/23/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import "SearchHeader.h"

@interface SearchHeader() <UISearchBarDelegate>

@property (nonatomic, strong) UITapGestureRecognizer *gestureRecognizer;
@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation SearchHeader

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.searchBar = [[UISearchBar alloc] initWithFrame:self.bounds];
        self.searchBar.delegate = self;
        [self addSubview:self.searchBar];
    }
    return self;
}

- (void)didMoveToSuperview {
    self.gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    UIView *topView = self.superview;
    while (topView.superview) {
        topView = topView.superview;
    }
    [topView addGestureRecognizer:self.gestureRecognizer];
}

- (void)onTap:(UITapGestureRecognizer *)gestureRecognizer {
    [self.searchBar resignFirstResponder];
}

#pragma mark UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"changed text %@", searchText);
//    SEL selector = NSSelectorFromString(@"searchBar:textDidChange:");
//    NSMethodSignature *signature  = [self methodSignatureForSelector:selector];
//    NSInvocation      *invocation = [NSInvocation invocationWithMethodSignature:signature];
//    invocation.selector = selector;
//    [invocation setArgument:&searchBar atIndex:2];
//    [invocation setArgument:&searchText atIndex:3];
//    [self propogateInvocationUpResponderChain:invocation];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    SEL selector = NSSelectorFromString(@"searchBarDoSearch:");
    [self propogateSelectorUpResponderChain:selector];
}

- (void)propogateSelectorUpResponderChain:(SEL)selector {
    UIResponder *nextResponder = self.nextResponder;
    NSString *text = self.searchBar.text;
    while (nextResponder) {
        if ([nextResponder respondsToSelector:selector]) {
            NSMethodSignature *signature  = [nextResponder methodSignatureForSelector:selector];
            NSInvocation      *invocation = [NSInvocation invocationWithMethodSignature:signature];
            invocation.selector = selector;
            invocation.target = nextResponder;
            [invocation setArgument:&text atIndex:2];
            [invocation invoke];
            break;
        }
        nextResponder = nextResponder.nextResponder;
    }
}


@end
