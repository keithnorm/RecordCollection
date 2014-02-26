//
//  AlbumCard.m
//  RecordCollection
//
//  Created by Keith Norman on 2/23/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import "AlbumCard.h"
#import "UIView+StyleClass.h"

@interface AlbumCard()

@property (nonatomic, weak) IBOutlet UIImageView *image;
@property (nonatomic, weak) IBOutlet UILabel *albumName;
@property (nonatomic, weak) IBOutlet UILabel *artistName;
@property (nonatomic, weak) IBOutlet UILabel *tracksCount;

@property (nonatomic, strong) SPAlbumBrowse *albumBrowse;

@end

@implementation AlbumCard

- (void)setAlbum:(SPAlbum *)album {
    _album = album;
    if (self.albumBrowse) {
        [self.albumBrowse removeObserver:self forKeyPath:@"loaded"];
    }
    self.albumBrowse = [[SPAlbumBrowse alloc] initWithAlbum:_album inSession:[SPSession sharedSession]];
    [self.albumBrowse addObserver:self forKeyPath:@"loaded" options:NSKeyValueObservingOptionNew context:NULL];
    if (self.album.cover) {
        [_album.cover addObserver:self forKeyPath:@"loaded" options:NSKeyValueObservingOptionNew context:NULL];
        [_album.cover startLoading];
    }
    [self refresh];
}

- (void)refresh {
    self.albumName.text = self.album.name;
    self.artistName.text = self.album.artist.name;
    self.tracksCount.text = [NSString stringWithFormat:@"%d tracks", [self.albumBrowse.tracks count]];
    self.image.image = self.album.cover.image;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"loaded"] && [[change objectForKey:NSKeyValueChangeNewKey] boolValue]) {
        [self refresh];
    }
}

- (void)awakeFromNib {
    self.albumName.styleClass = @"strongLabel";
}

- (void)dealloc {
    [self.albumBrowse removeObserver:self forKeyPath:@"loaded"];
    if ([self.album.cover observationInfo]) {
        [self.album.cover removeObserver:self forKeyPath:@"loaded"];
    }
}

- (void)setImageBorder:(CSSBorder *)imageBorder {
    [self.image setBorder:imageBorder];
}

- (void)setImageBorderRadius:(CSSBorderRadius *)imageBorderRadius {
    [self.image setBorderRadius:imageBorderRadius];
}

@end
