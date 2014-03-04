//
//  CoverImagePresenter.h
//  RecordCollection
//
//  Created by Keith Norman on 3/3/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlbumPresenterProtocol.h"
#import "Album.h"

@interface CoverImagePresenter : NSObject <CoverImagePresenterProtocol>

@property (nonatomic, strong) UIImage *image;

- (instancetype)initWithAlbum:(Album *)album;

@end
