//
//  AlbumCard.h
//  RecordCollection
//
//  Created by Keith Norman on 2/23/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CocoaLibSpotify/CocoaLibSpotify.h>
#import "UIView+CSS.h"
#import "AlbumPresenterProtocol.h"

@interface AlbumCard : UIView

@property (nonatomic, strong) id<AlbumPresenterProtocol> album;
@property (nonatomic, strong) UIImage *image;

@property (strong, nonatomic) CSSBorderRadius *imageBorderRadius UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) CSSBorder *imageBorder;

- (void)refresh;

@end
