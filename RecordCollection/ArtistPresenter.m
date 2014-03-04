//
//  ArtistPresenter.m
//  RecordCollection
//
//  Created by Keith Norman on 3/3/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import "ArtistPresenter.h"

@implementation ArtistPresenter

- (instancetype)initWithAlbum:(Album *)album {
    self = [super init];
    if (self) {
        _name = album.artistName;
    }
    return self;
}

@end
