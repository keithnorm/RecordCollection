//
//  AlbumPresenter.m
//  RecordCollection
//
//  Created by Keith Norman on 3/3/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import "AlbumPresenter.h"

@implementation AlbumPresenter

- (instancetype)initWithAlbum:(Album *)album {
    self = [super init];
    if (self) {
        _name = album.name;
        _spotifyURL = album.spotifyUrl;
        _artist = [[ArtistPresenter alloc] initWithAlbum:album];
        _cover = [[CoverImagePresenter alloc] initWithAlbum:album];
    }
    return self;
}

@end
