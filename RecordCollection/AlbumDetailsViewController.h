//
//  AlbumDetailsViewController.h
//  RecordCollection
//
//  Created by Keith Norman on 2/23/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CocoaLibSpotify/CocoaLibSpotify.h>
#import "AlbumPresenterProtocol.h"

@interface AlbumDetailsViewController : UIViewController

@property (nonatomic, strong) id<AlbumPresenterProtocol> album;
@property (nonatomic, strong) SPTrack *track;

@end


