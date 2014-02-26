//
//  ViewController.m
//  RecordCollection
//
//  Created by Keith Norman on 2/23/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import "ViewController.h"
#import "Constants.h"
#import "NSTimer+Blocks.h"
#import "AlbumCell.h"
#import "User.h"
#import "Album.h"
#import "NSManagedObject+Helper.h"
#import "SearchHeader.h"
#import "AlbumDetailsViewController.h"

#import <CocoaLibSpotify/CocoaLibSpotify.h>

const NSUInteger kSearchTextLengthThreshold = 4;

@interface ViewController () <SPSessionDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) SPToplist *topList;
@property (nonatomic, strong) NSArray *albums;
@property (nonatomic, strong) SPSearch *currentSearch;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

// Outlets!
@property (nonatomic, weak) IBOutlet UICollectionView *albumsCollectionView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    SPSession *session = [SPSession sharedSession];
//    [self.albumsCollectionView registerClass:[SearchHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SearchHeader"];
//    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.albumsCollectionView.collectionViewLayout;
//    layout.headerReferenceSize = CGSizeMake(320, 50);
//    self.navigationController.navigationBarHidden = YES;
    self.title = @"Most Played";
    
    User *user = [User first];
    if (user) {
        [session attemptLoginWithUserName:user.userName existingCredential:user.credentials];
    } else if (session.connectionState != SP_CONNECTION_STATE_LOGGED_IN) {
        SPLoginViewController *controller = [SPLoginViewController loginControllerForSession:session];
        [self.navigationController presentViewController:controller animated:YES completion:nil];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTopAlbums) name:SPSessionLoginDidSucceedNotification object:nil];
}

- (void)showTopAlbums {
    self.title = @"Recently Played";
    SPDispatchAsync(^{
        if (self.topList) {
            [self.topList removeObserver:self forKeyPath:@"loaded"];
        }
        self.topList = [SPToplist toplistForCurrentUserInSession:[SPSession sharedSession]];
        [self.topList addObserver:self forKeyPath:@"loaded" options:NSKeyValueObservingOptionNew context:NULL];
    });
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"loaded"] && [[change objectForKey:NSKeyValueChangeNewKey] boolValue]) {
        if ([object isKindOfClass:[SPToplist class]]) {
            self.albums = self.topList.albums;
            [self.albumsCollectionView reloadData];
        } else if ([object isKindOfClass:[SPSearch class]]) {
            self.albums = self.currentSearch.albums;
            [self.albumsCollectionView reloadData];
        }
    }
}

- (void)dealloc {
    [self.topList removeObserver:self forKeyPath:@"loaded"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"albumDetails"]) {
        NSIndexPath *indexPath = [self.albumsCollectionView indexPathForCell:sender];
        SPAlbum *album = [self.albums objectAtIndex:indexPath.row];
        AlbumDetailsViewController *vc = segue.destinationViewController;
        vc.album = album;
    }
}

#pragma mark UICollectionViewDelegate

#pragma UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.albums count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AlbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AlbumCell" forIndexPath:indexPath];
    SPAlbum *album = [self.albums objectAtIndex:indexPath.row];
    cell.album = album;
    return cell;
}

#pragma mark Interaction Handling

- (void)setSearchText:(NSString *)searchText {
    _searchText = searchText;
    if ([[[self.navigationController viewControllers] objectAtIndex:0] isEqual:self]) {
        [self.navigationController popToViewController:self animated:NO];
    }
    
    if ([searchText isEqualToString:@"Recently Played"]) {
        [self showTopAlbums];
        return;
    }
    
    if ([searchText isEqualToString:@"My Collection"]) {
        User *user = [User first];
        self.title = @"My Collection";
        NSMutableArray *albums = [[NSMutableArray alloc] init];
        for (Album *album in user.albums) {
            NSLog(@"yo yo %@", album);
            [SPAlbum albumWithAlbumURL:album.spotifyUrl inSession:[SPSession sharedSession] callback:^(SPAlbum *album) {
                if (album) {
                    [albums addObject:album];
                    self.albums = albums;
                    [self.albumsCollectionView reloadData];
                }
            }];
        }
        return;
    }
    
    SPDispatchAsync(^{
        if (self.currentSearch) {
            [self.currentSearch removeObserver:self forKeyPath:@"loaded"];
        }
        self.currentSearch = [SPSearch searchWithSearchQuery:searchText inSession:[SPSession sharedSession]];
        [self.currentSearch addObserver:self forKeyPath:@"loaded" options:NSKeyValueObservingOptionNew context:NULL];
        self.title = searchText;
    });
}


@end
