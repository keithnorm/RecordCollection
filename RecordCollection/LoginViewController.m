//
//  LoginViewController.m
//  RecordCollection
//
//  Created by Keith Norman on 3/3/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIViewController *internalLoginViewController = [[self viewControllers] objectAtIndex:0];
    if (internalLoginViewController && [internalLoginViewController respondsToSelector:@selector(edgesForExtendedLayout)]) {
        [internalLoginViewController setEdgesForExtendedLayout:UIRectEdgeNone];
    }
}

@end
