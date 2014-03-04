//
//  CoverImagePresenter.m
//  RecordCollection
//
//  Created by Keith Norman on 3/3/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import "CoverImagePresenter.h"

@implementation CoverImagePresenter

- (instancetype)initWithAlbum:(Album *)album {
    self = [super init];
    if (self) {
        _image = album.cover;
    }
    return self;
}

@end
