//
//  AlbumDetailsViewController.m
//  RecordCollection
//
//  Created by Keith Norman on 2/23/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import "AlbumDetailsViewController.h"
#import "AlbumDetailsView.h"
#import "UIView+Event.h"

@interface AlbumDetailsViewController ()

@end

@implementation AlbumDetailsViewController

- (void)setAlbum:(SPAlbum *)album {
    _album = album;
    self.title = album.name;
    AlbumDetailsView *albumDetailsView = (AlbumDetailsView *)self.view;
    albumDetailsView.album = album;
}

@end
