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
    return self;
}

- (void)awakeFromNib {
    self.trackList.delegate = self;
    self.trackList.dataSource = self;
//    self.trackList.contentInset = UIEdgeInsetsMake(0, 0, 150, 0);
    UIView *tableHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.trackList.bounds.size.width, self.image.bounds.size.height - 20)];
    self.trackList.backgroundColor = [UIColor clearColor];
    self.trackList.tableHeaderView = tableHeader;
    self.trackList.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
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
    CGFloat offset = scrollView.contentOffset.y;
    if (offset < 0) {
        CGRect imageFrame = self.image.frame;
        imageFrame.size.height = 320 + -offset * .2;
        imageFrame.size.width = 320 + -offset * .2;
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
    [[PlaybackManager sharedManager] playTrack:track callback:^(NSError *error) {
        NSLog(@"cool %@", error);
    }];
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
