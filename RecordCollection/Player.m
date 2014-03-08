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
#import "PlayQueue.h"
#import "UIView+Event.h"
#import "ScrubberBar.h"
#import "UIView+StyleClass.h"
#import "NextButton.h"
#import <CocoaLibSpotify/CocoaLibSpotify.h>

@interface Player() <UIGestureRecognizerDelegate>

@property (nonatomic, weak) IBOutlet UILabel *artistName;
@property (nonatomic, weak) IBOutlet UILabel *songName;
@property (nonatomic, weak) IBOutlet PlayPauseButton *playPauseButton;
@property (nonatomic, weak) IBOutlet NextButton *nextButton;
@property (nonatomic, weak) IBOutlet ScrubberBar *scrubberBar;
@property (nonatomic, weak) IBOutlet UIView *playerBar;


- (IBAction)onNextButton:(id)sender;

@end

@implementation Player

+(instancetype)sharedPlayer {
    static Player *player = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [[[NSBundle mainBundle] loadNibNamed:@"Player" owner:self options:nil] objectAtIndex:0];
        player.translatesAutoresizingMaskIntoConstraints = NO;
    });
    return player;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.songName.styleClass = @"strongLabel";
    self.artistName.styleClass = @"caption1Label";
    [self.playPauseButton addTarget:self action:@selector(pressPlayPause:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setup {
    PlaybackManager *playbackManager = [PlaybackManager sharedManager];
    SPSession *session = [SPSession sharedSession];
    [session addObserver:self forKeyPath:@"playing" options:NSKeyValueObservingOptionNew context:NULL];
    [playbackManager addObserver:self forKeyPath:@"currentTrack" options:NSKeyValueObservingOptionNew context:NULL];
    [playbackManager addObserver:self forKeyPath:@"trackPosition" options:NSKeyValueObservingOptionNew context:NULL];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    gestureRecognizer.cancelsTouchesInView = NO;
    gestureRecognizer.delegate = self;
    [self addGestureRecognizer:gestureRecognizer];
    self.hidden = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.songName.styleClass = @"strongLabel";
    self.artistName.styleClass = @"caption2Label";
}

- (void)dealloc {
    PlaybackManager *playbackManager = [PlaybackManager sharedManager];
    SPSession *session = [SPSession sharedSession];
    [playbackManager removeObserver:self forKeyPath:@"currentTrack"];
    [playbackManager removeObserver:self forKeyPath:@"trackPosition"];
    [session removeObserver:self forKeyPath:@"playing"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"currentTrack"]) {
        [self refresh];
    } else if ([keyPath isEqualToString:@"playing"] && [[change valueForKey:NSKeyValueChangeNewKey] boolValue]) {
        self.hidden = NO;
    } else if ([keyPath isEqualToString:@"trackPosition"]){
        self.scrubberBar.value = [[change valueForKey:NSKeyValueChangeNewKey] floatValue];
    }
}

- (void)refresh {
    PlaybackManager *playbackManager = [PlaybackManager sharedManager];
    self.songName.text = playbackManager.currentTrack.name;
    self.scrubberBar.max = playbackManager.currentTrack.duration;
    if ([playbackManager.currentTrack.artists count]) {
        SPArtist *artist = [playbackManager.currentTrack.artists objectAtIndex:0];
        self.artistName.text = artist.name;
    }
}

- (CGSize)intrinsicContentSize {
    return self.bounds.size;
}

- (void)tintColorDidChange {
//    self.backgroundColor = self.tintColor;
}

#pragma mark User Interaction

- (IBAction)pressPlayPause:(id)sender {
    [[SPSession sharedSession] setPlaying:![[SPSession sharedSession] isPlaying]];
}

- (IBAction)onNextButton:(id)sender {
    [self fireEvent:@"userDidSelectPlayNext" withObject:self];
}

- (void)onTap:(UITapGestureRecognizer *)gestureRecognizer {
    PlaybackManager *playbackManager = [PlaybackManager sharedManager];
    [self fireEvent:@"selectTrackFromPlayer" withObject:playbackManager.currentTrack];
}

#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return [touch.view isEqual:self.playerBar];
}


@end
