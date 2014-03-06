//
//  IntroAutomator.h
//  RecordCollection
//
//  Created by Keith Norman on 3/6/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICSDrawerController.h"
#import "ViewController.h"
#import "MenuViewController.h"

@interface IntroAutomator : NSObject

@property (strong, nonatomic) ICSDrawerController *drawer;
@property (strong, nonatomic) ViewController *listController;
@property (strong, nonatomic) MenuViewController<UISearchBarDelegate> *menu;;


- (id)initWithDrawer:(ICSDrawerController *)drawer list:(ViewController *)listController menu:(MenuViewController *)menu;

- (void)start;

@end
