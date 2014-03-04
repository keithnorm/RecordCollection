//
//  AlbumCell.h
//  RecordCollection
//
//  Created by Keith Norman on 2/23/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CocoaLibSpotify/CocoaLibSpotify.h>
#import "OCAEditableCollectionViewFlowLayoutCell.h"
#import "AlbumPresenterProtocol.h"

@interface AlbumCell : OCAEditableCollectionViewFlowLayoutCell

@property (nonatomic, strong) id<AlbumPresenterProtocol> album;
@property (nonatomic, strong) UIImage *image;

@end
