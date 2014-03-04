//
//  PlayQueue.m
//  RecordCollection
//
//  Created by Keith Norman on 3/1/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import "PlayQueue.h"

@interface PlayQueue()

@property (nonatomic, strong) SPAlbumBrowse *albumMeta;

@end

@implementation PlayQueue

+ (instancetype)sharedQueue {
    static PlayQueue *queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = [[self alloc] init];
    });
    return queue;
}

- (void)setCurrentAlbum:(SPAlbum *)currentAlbum {
    _currentAlbum = currentAlbum;
    SPSession *session = [SPSession sharedSession];
    _albumMeta = [SPAlbumBrowse browseAlbum:currentAlbum inSession:session];
}

- (void)setCurrentTrack:(SPTrack *)currentTrack {
    _currentTrack = currentTrack;
    self.currentAlbum = currentTrack.album;
    self.currentTrackIndex = currentTrack.trackNumber;
}

- (BOOL)hasNext {
    return self.currentTrackIndex < [self.albumMeta.tracks count];
}
- (SPTrack *)next {
    return [self.albumMeta.tracks objectAtIndex:self.currentTrackIndex++];
}

@end
