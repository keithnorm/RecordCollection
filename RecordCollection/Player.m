//
//  Player.m
//  RecordCollection
//
//  Created by Keith Norman on 2/24/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import "Player.h"
#import "PlaybackManager.h"
#import "PlayPauseButton.h"
#import "UIView+StyleClass.h"
#import "NSTimer+Blocks.h"
#import <CocoaLibSpotify/CocoaLibSpotify.h>

@interface Player()

@property (nonatomic, weak) IBOutlet UILabel *artistName;
@property (nonatomic, weak) IBOutlet UILabel *songName;
@property (nonatomic, weak) IBOutlet PlayPauseButton *playPauseButton;


@end

@implementation Player

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.playPauseButton addTarget:self action:@selector(pressPlayPause:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setup {
    PlaybackManager *playbackManager = [PlaybackManager sharedManager];
    SPSession *session = [SPSession sharedSession];
    [session addObserver:self forKeyPath:@"playing" options:NSKeyValueObservingOptionNew context:NULL];
    [playbackManager addObserver:self forKeyPath:@"currentTrack" options:NSKeyValueObservingOptionNew context:NULL];
    self.hidden = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.songName.styleClass = @"caption1Label";
    self.artistName.styleClass = @"caption2Label";
}

- (void)dealloc {
    PlaybackManager *playbackManager = [PlaybackManager sharedManager];
    SPSession *session = [SPSession sharedSession];
    [playbackManager removeObserver:self forKeyPath:@"currentTrack"];
    [session removeObserver:self forKeyPath:@"playing"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"currentTrack"]) {
        [self refresh];
    } else if ([keyPath isEqualToString:@"playing"] && [[change valueForKey:NSKeyValueChangeNewKey] boolValue]) {
        self.hidden = NO;
    }
}

- (void)refresh {
    PlaybackManager *playbackManager = [PlaybackManager sharedManager];
    self.songName.text = playbackManager.currentTrack.name;
    if ([playbackManager.currentTrack.artists count]) {
        SPArtist *artist = [playbackManager.currentTrack.artists objectAtIndex:0];
        self.artistName.text = artist.name;
    }
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(320, 50);
}

- (void)tintColorDidChange {
//    self.backgroundColor = self.tintColor;
}

#pragma mark User Interaction

- (IBAction)pressPlayPause:(id)sender {
    [[SPSession sharedSession] setPlaying:![[SPSession sharedSession] isPlaying]];
}

@end
