//
//  AlbumPresenter.h
//  RecordCollection
//
//  Created by Keith Norman on 3/3/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlbumPresenterProtocol.h"
#import "CoverImagePresenter.h"
#import "ArtistPresenter.h"
#import "Album.h"

@interface AlbumPresenter : NSObject <AlbumPresenterProtocol>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSURL *spotifyURL;
@property (nonatomic, strong) ArtistPresenter *artist;
@property (nonatomic, strong) CoverImagePresenter *cover;

- (instancetype)initWithAlbum:(Album *)album;

@end
