//
//  AlbumDetailsView.m
//  RecordCollection
//
//  Created by Keith Norman on 2/23/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import "AlbumDetailsView.h"
#import "PlaybackManager.h"
#import "UIView+Event.h"

@interface AlbumDetailsView() <UITableViewDelegate, UITableViewDataSource, SPSessionDelegate>
- (IBAction)tapAddToCollection:(id)sender;

@property (nonatomic, strong) SPAlbumBrowse *albumBrowse;
@property (nonatomic, strong) SPPlaybackManager *playbackManager;


@property (nonatomic, weak) IBOutlet UIImageView *image;
@property (nonatomic, weak) IBOutlet UITableView *trackList;

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
    return self;
}

- (void)awakeFromNib {
    self.trackList.delegate = self;
    self.trackList.dataSource = self;
    self.trackList.contentInset = UIEdgeInsetsMake(0, 0, 150, 0);
}

- (void)setAlbum:(SPAlbum *)album {
    _album = album;
    if (self.albumBrowse) {
        [self.albumBrowse removeObserver:self forKeyPath:@"loaded"];
    }
    self.albumBrowse = [SPAlbumBrowse browseAlbum:album inSession:[SPSession sharedSession]];
    [self.albumBrowse addObserver:self forKeyPath:@"loaded" options:NSKeyValueObservingOptionNew context:NULL];
    [self refresh];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.trackList.frame = CGRectMake(0, 320, 320, self.trackList.bounds.size.height);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"loaded"]) {
        [self refresh];
    }
}

- (void)refresh {
    self.image.image = self.album.cover.image;
    [self.trackList reloadData];
}

- (void)dealloc {
    [self.albumBrowse removeObserver:self forKeyPath:@"loaded"];
}

- (void)updateConstraints {
    [super updateConstraints];
    [self setNeedsDisplay];
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    CGRect frame = scrollView.frame;
    CGFloat target = frame.origin.y - scrollView.contentOffset.y;
//    NSLog(@"offset is %f target is %f", scrollView.contentOffset.y, target);
    if (target >= 0 && target <= 320) {
        scrollView.contentOffset = CGPointMake(0, 0);
        frame.origin.y = target;
        scrollView.frame = frame;
    }
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
    [[PlaybackManager sharedManager] playTrack:track callback:^(NSError *error) {
        NSLog(@"cool %@", error);
    }];
}

- (IBAction)tapAddToCollection:(id)sender {
    [self fireEvent:@"didAddAlbumToCollection" withObject:self.album];
}
@end
