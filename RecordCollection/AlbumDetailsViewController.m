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

- (void)setAlbum:(id<AlbumPresenterProtocol>)album {
    _album = album;
    self.title = album.name;
    AlbumDetailsView *albumDetailsView = (AlbumDetailsView *)self.view;
    albumDetailsView.album = album;
}

- (void)setTrack:(SPTrack *)track {
    _track = track;
    AlbumDetailsView *albumDetailsView = (AlbumDetailsView *)self.view;
    albumDetailsView.track = track;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.alpha = 0.5f;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.alpha = 1.0f;
}

- (void)didScroll:(NSNumber *)offset {
    if ([offset integerValue] >= 239) {
        [UIView animateWithDuration:0.3 animations:^{
            self.navigationController.navigationBar.alpha = 1.0f;
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.navigationController.navigationBar.alpha = 0.5f;
        }];
    }
}

@end
