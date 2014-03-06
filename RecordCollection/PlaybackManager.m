//
//  PlaybackManager.m
//  RecordCollection
//
//  Created by Keith Norman on 2/24/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import "PlaybackManager.h"
#import "PlayQueue.h"

@import MediaPlayer;

NSString * const RCPlayerDidBeginPlayingTrackNotification = @"RCPlayerDidBeginPlayingTrackNotification";

@interface PlaybackManager()

@end

@implementation PlaybackManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static PlaybackManager *manager;
    dispatch_once(&onceToken, ^{
        SPSession *session = [SPSession sharedSession];
        manager = [[PlaybackManager alloc] initWithPlaybackSession:session];
    });
    return manager;
}

- (void)playTrack:(SPTrack *)aTrack callback:(SPErrorableOperationCallback)block {
    [super playTrack:aTrack callback:block];
    
    NSMutableDictionary *songInfo = [[NSMutableDictionary alloc] init];
    
    [songInfo setObject:aTrack.name forKey:MPMediaItemPropertyTitle];
    [songInfo setObject:[[aTrack.artists objectAtIndex:0] name] forKey:MPMediaItemPropertyArtist];
    [songInfo setObject:aTrack.album.name forKey:MPMediaItemPropertyAlbumTitle];
    [songInfo setObject:@(aTrack.duration) forKey:MPMediaItemPropertyPlaybackDuration];
    [songInfo setObject:@(self.trackPosition) forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    [songInfo setObject:@(1) forKey:MPNowPlayingInfoPropertyPlaybackRate];

    
    if (aTrack.album.cover.image) {
        MPMediaItemArtwork *albumArt = [[MPMediaItemArtwork alloc] initWithImage:aTrack.album.cover.image];
        [songInfo setObject:albumArt forKey:MPMediaItemPropertyArtwork];
    }
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songInfo];
    [[PlayQueue sharedQueue] setCurrentTrack:aTrack];
    self.currentTrack = aTrack;
    [[NSNotificationCenter defaultCenter] postNotificationName:RCPlayerDidBeginPlayingTrackNotification object:self];
}

- (void)sessionDidEndPlayback:(id<SPSessionPlaybackProvider>)aSession {
    [self playNext];
}

- (void)playNext {
    PlayQueue *queue = [PlayQueue sharedQueue];
    if ([queue hasNext]) {
        [self playTrack:[queue next] callback:^(NSError *error) {
            NSLog(@"Error initiating playback: %@", [error localizedDescription]);
        }];
    }
}

- (void)playPrev {
    PlayQueue *queue = [PlayQueue sharedQueue];
    if ([queue hasPrev]) {
        [self playTrack:[queue prev] callback:^(NSError *error) {
            NSLog(@"Error initiating playback: %@", [error localizedDescription]);
        }];
    }
}

@end
