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

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *albumName;
@property (nonatomic, weak) IBOutlet UILabel *artistName;
@property (nonatomic, weak) IBOutlet UILabel *tracksCount;

@property (nonatomic, strong) SPAlbumBrowse *albumBrowse;

@property (nonatomic, assign) BOOL viewLoaded;

@end

@implementation AlbumCard

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _viewLoaded = NO;
    }
    return self;
}

- (void)setAlbum:(id<AlbumPresenterProtocol>)album {
    _album = album;
    if (album) {
//        self.albumBrowse = [[SPAlbumBrowse alloc] initWithAlbum:_album inSession:[SPSession sharedSession]];
        __weak AlbumCard *weakSelf = self;
        
        if ([album isKindOfClass:[SPAlbum class]]) {
            [SPAsyncLoading waitUntilLoaded:album timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
                if (weakSelf.superview) {
                    [weakSelf refresh];
                }
            }];
        }
        
        [self refresh];
    }
}

- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
}

- (void)refresh {
    if (self.viewLoaded) {
        self.albumName.text = self.album.name;
        self.artistName.text = self.album.artist.name;
        self.imageView.image = self.album.cover.image;
    }
}

- (void)awakeFromNib {
    self.albumName.styleClass = @"strongLabel";
    self.viewLoaded = YES;
}

- (void)setImageBorder:(CSSBorder *)imageBorder {
    [self.imageView setBorder:imageBorder];
}

- (void)setImageBorderRadius:(CSSBorderRadius *)imageBorderRadius {
    [self.imageView setBorderRadius:imageBorderRadius];
}

- (void)dealloc {
    self.album = nil;
}

@end
