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

@interface AlbumCard : UIView

@property (nonatomic, strong) SPAlbum *album;

@property (strong, nonatomic) CSSBorderRadius *imageBorderRadius UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) CSSBorder *imageBorder;

@end
