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
    self.albumCard = [views objectAtIndex:0];
    [self.contentView addSubview:self.albumCard];
}

- (void)setAlbum:(SPAlbum *)album {
    _album = album;
    self.albumCard.album = album;
}


@end
