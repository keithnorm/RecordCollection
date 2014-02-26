//
//  PlaybackManager.m
//  RecordCollection
//
//  Created by Keith Norman on 2/24/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import "PlaybackManager.h"

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
    self.currentTrack = aTrack;
}

@end
