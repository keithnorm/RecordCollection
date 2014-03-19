//
//  AlbumCell.m
//  RecordCollection
//
//  Created by Keith Norman on 2/23/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import "AlbumCell.h"
#import "AlbumCard.h"


@interface AlbumCell()

@property (nonatomic, strong) AlbumCard *albumCard;

@end

@implementation AlbumCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"AlbumCard" owner:nil options:nil];
    if (self.albumCard) {
        [self.albumCard removeFromSuperview];
        self.albumCard = nil;
    }
    self.albumCard = [views objectAtIndex:0];
    [self.contentView addSubview:self.albumCard];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[card]|" options:0 metrics:nil views:@{@"card": self.albumCard}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[card]|" options:0 metrics:nil views:@{@"card": self.albumCard}]];
}

- (void)setAlbum:(id<AlbumPresenterProtocol>)album {
    _album = album;
    self.albumCard.album = album;
}

- (void)setImage:(UIImage *)image {
    self.albumCard.image = image;
}

- (void)dealloc {
    self.albumCard = nil;
    [self.albumCard removeFromSuperview];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.albumCard.album = nil;
    [self.albumCard refresh];
}

@end