//
//  PlayQueue.h
//  RecordCollection
//
//  Created by Keith Norman on 3/1/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaLibSpotify/CocoaLibSpotify.h>

@interface PlayQueue : NSObject

@property (nonatomic, strong) SPAlbum *currentAlbum;
@property (nonatomic, strong) SPTrack *currentTrack;
@property (nonatomic, assign) NSUInteger currentTrackIndex;

+ (instancetype)sharedQueue;

- (BOOL)hasNext;
- (SPTrack *)next;
- (BOOL)hasPrev;
- (SPTrack *)prev;

@end
