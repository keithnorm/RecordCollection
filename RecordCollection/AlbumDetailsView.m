//
//  AlbumDetailsView.m
//  RecordCollection
//
//  Created by Keith Norman on 2/23/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import "AlbumDetailsView.h"
#import "PlaybackManager.h"
#import "PlayQueue.h"
#import "UIView+Event.h"
#import "Album.h"
#import "Player.h"
#import "UIView+StyleClass.h"
#import "NSManagedObject+Helper.h"

@import MediaPlayer;

@interface AlbumDetailsView() <UITableViewDelegate, UITableViewDataSource, SPSessionDelegate>
- (IBAction)tapAddToCollection:(id)sender;

@property (nonatomic, strong) SPAlbumBrowse *albumBrowse;
@property (nonatomic, strong) SPPlaybackManager *playbackManager;


@property (nonatomic, weak) IBOutlet UIImageView *image;
@property (nonatomic, weak) IBOutlet UITableView *trackList;
@property (nonatomic, weak) IBOutlet UIButton *addToCollectionBtn;


@end

@implementation AlbumDetailsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBeginPlayingTrack:) name:RCPlayerDidBeginPlayingTrackNotification object:nil];
    return self;
}

- (void)didBeginPlayingTrack:(NSNotification *)notification {
    SPTrack *track = [[PlaybackManager sharedManager] currentTrack];
    NSIndexPath *indexOfTrack = [NSIndexPath indexPathForRow:track.trackNumber - 1 inSection:0];
    if ([track.album.spotifyURL isEqual:self.album.spotifyURL] && [self.trackList cellForRowAtIndexPath:indexOfTrack]) {
        [self.trackList selectRowAtIndexPath:indexOfTrack animated:YES scrollPosition:UITableViewScrollPositionBottom];
    }
}

- (void)awakeFromNib {
    self.trackList.delegate = self;
    self.trackList.dataSource = self;
//    self.trackList.contentInset = UIEdgeInsetsMake(0, 0, 150, 0);
    UIView *tableHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.trackList.bounds.size.width, self.image.bounds.size.height - 20)];
    self.trackList.backgroundColor = [UIColor clearColor];
    self.trackList.tableHeaderView = tableHeader;
    Player *player = [Player sharedPlayer];
    self.trackList.contentInset = UIEdgeInsetsMake(0, 0, player.bounds.size.height, 0);
}

- (void)setAlbum:(id<AlbumPresenterProtocol>)album {
    _album = album;
    
    if ([album isKindOfClass:[SPAlbum class]]) {
        self.albumBrowse = [SPAlbumBrowse browseAlbum:(SPAlbum *)album inSession:[SPSession sharedSession]];
        __weak AlbumDetailsView *weakSelf = self;
        [SPAsyncLoading waitUntilLoaded:self.albumBrowse timeout:3.0 then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
            [weakSelf refresh];
        }];
        [self refresh];
    } else {
        [SPAlbum albumWithAlbumURL:album.spotifyURL inSession:[SPSession sharedSession] callback:^(SPAlbum *album) {
            self.albumBrowse = [SPAlbumBrowse browseAlbum:(SPAlbum *)album inSession:[SPSession sharedSession]];
            __weak AlbumDetailsView *weakSelf = self;
            _album = (id<AlbumPresenterProtocol>)album;
            [SPAsyncLoading waitUntilLoaded:self.albumBrowse timeout:3.0 then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
                if (self) {
                    [weakSelf refresh];
                }
            }];
        }];
    }
}

- (void)setTrack:(SPTrack *)track {
    _track = track;
    NSIndexPath *indexOfTrack = [NSIndexPath indexPathForRow:track.trackNumber - 1 inSection:0];
    if (track) {
        if (![track isEqual:[[PlaybackManager sharedManager] currentTrack]]) {
            [[PlaybackManager sharedManager] playTrack:track callback:nil];
        }
        if ([self.trackList cellForRowAtIndexPath:indexOfTrack]) {
            [self.trackList selectRowAtIndexPath:indexOfTrack animated:YES scrollPosition:UITableViewScrollPositionBottom];
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.track && self.track.trackNumber < [self.trackList numberOfRowsInSection:0]) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.track.trackNumber - 1 inSection:0];
        [self.trackList selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
    }
}

- (void)refresh {
    if (self && self.album) {
        [SPAsyncLoading waitUntilLoaded:self.album.cover timeout:3.0 then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
            self.image.image = self.album.cover.image;
        }];
        
        [self.trackList reloadData];
        if ([Album findFirstWithDict:@{@"spotifyUrl": self.album.spotifyURL}]) {
            self.addToCollectionBtn.hidden = YES;
        }
    }
}

- (void)updateConstraints {
    [super updateConstraints];
    [self setNeedsDisplay];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y;
    if (offset < 0) {
        CGRect imageFrame = self.image.frame;
        imageFrame.size.height = self.bounds.size.width + -offset * .2;
        imageFrame.size.width = self.bounds.size.width + -offset * .2;
        self.image.frame = imageFrame;
    }
    
    if (offset >= 0) {
        CGRect imageFrame = self.image.frame;
        imageFrame.origin.y = 0 - offset * .2;
        self.image.frame = imageFrame;
    }
    [self fireEvent:@"didScroll" withObject:@(offset)];
    
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.albumBrowse.tracks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SPTrack *track = [self.albumBrowse.tracks objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TrackCell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%d - %@", track.trackNumber, track.name];
    return cell;
}

#pragma mark UITableViewDelegate 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SPTrack *track = [self.albumBrowse.tracks objectAtIndex:indexPath.row];
    [[PlaybackManager sharedManager] playTrack:track callback:nil];
}

- (IBAction)tapAddToCollection:(id)sender {
    [self fireEvent:@"didAddAlbumToCollection" withObject:self.album];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    if (view == self.trackList) {
        return nil;
    }
    return view;
}
@end
