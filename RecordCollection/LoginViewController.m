//
//  LoginViewController.m
//  RecordCollection
//
//  Created by Keith Norman on 3/3/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import "LoginViewController.h"
#import <CocoaLibSpotify/CocoaLibSpotify.h>
#import <CocoaLibSpotify/SPLoginLogicViewController.h>

@interface LoginViewController ()

@property (nonatomic, readwrite) SPSession *session;

@end

@implementation LoginViewController

@synthesize session = _session;

-(id)initWithSession:(SPSession *)aSession {
	
	self = [super initWithRootViewController:[[SPLoginLogicViewController alloc] initWithSession:aSession]];
	
	if (self) {
		self.session = aSession;
		self.navigationBar.barStyle = UIBarStyleBlack;
		self.modalPresentationStyle = UIModalPresentationFormSheet;
		self.dismissesAfterLogin = YES;
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:NSSelectorFromString(@"sessionDidLogin:")
													 name:SPSessionLoginDidSucceedNotification
												   object:self.session];
		
	}
	return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIViewController *internalLoginViewController = [[self viewControllers] objectAtIndex:0];
    if (internalLoginViewController && [internalLoginViewController respondsToSelector:@selector(edgesForExtendedLayout)]) {
        [internalLoginViewController setEdgesForExtendedLayout:UIRectEdgeNone];
    }
}

@end
