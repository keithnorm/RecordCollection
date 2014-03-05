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
#import "Album+BusinessLogic.h"
#import "NSManagedObject+Helper.h"
#import "SearchHeader.h"
#import "AlbumDetailsViewController.h"
#import "OCAEditableCollectionViewFlowLayout.h"
#import "LoginViewController.h"
#import "Underscore.h"
#import "AlbumPresenter.h"
#import "CoreDataHelper.h"
#import <MBProgressHUD/MBProgressHUD.h>

#import <CocoaLibSpotify/CocoaLibSpotify.h>


const NSUInteger kSearchTextLengthThreshold = 4;

@interface ViewController () <SPSessionDelegate, UICollectionViewDataSource, UICollectionViewDelegate, OCAEditableCollectionViewDelegateFlowLayout, OCAEditableCollectionViewDataSource>

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
    self.title = @"Most Played";
    
    User *user = [User first];
    if (user) {
        [session attemptLoginWithUserName:user.userName existingCredential:user.credentials];
    } else if (session.connectionState != SP_CONNECTION_STATE_LOGGED_IN) {
        LoginViewController *controller = [LoginViewController loginControllerForSession:session];
        [self.navigationController presentViewController:controller animated:YES completion:nil];
    }
    self.albumsCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    self.albumsCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(somethingChanged) name:@"SomethingChanged" object:nil];
}


- (void)somethingChanged {
    NSLog(@"something changed");
    if ([self.searchText isEqualToString:@"My Collection"]) {
        self.searchText = @"My Collection";
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTopAlbums) name:SPSessionLoginDidSucceedNotification object:nil];
}

- (void)viewDidLayoutSubviews {
    
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
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}

- (void)dealloc {
    [self.topList removeObserver:self forKeyPath:@"loaded"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"albumDetails"]) {
        NSIndexPath *indexPath = [self.albumsCollectionView indexPathForCell:sender];
        id<AlbumPresenterProtocol> album = [self.albums objectAtIndex:indexPath.row];
        AlbumDetailsViewController *vc = segue.destinationViewController;
        vc.album = album;
    }
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    
}


- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)didBeginEditingForCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout {
    UIBarButtonItem *doneEditingButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditing)];
    self.navigationItem.rightBarButtonItem = doneEditingButton;
}

- (void)didEndEditingForCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout {
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)doneEditing {
    OCAEditableCollectionViewFlowLayout *layout = ((OCAEditableCollectionViewFlowLayout *)self.albumsCollectionView.collectionViewLayout);
    layout.editModeOn = NO;
    [layout invalidateLayout];
    [layout.delegate didEndEditingForCollectionView:self.albumsCollectionView layout:layout];
}

- (BOOL)shouldEnableEditingForCollectionView: (UICollectionView *)collectionView
                                      layout: (UICollectionViewLayout *)collectionViewLayout {
    return [self.searchText isEqualToString:@"My Collection"];
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
    id<AlbumPresenterProtocol> album = [self.albums objectAtIndex:indexPath.row];
    cell.album = album;
    if ([album isKindOfClass:[SPAlbum class]]) {
        [SPAsyncLoading waitUntilLoaded:album.cover timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
            AlbumCell *cell = (AlbumCell *)[collectionView cellForItemAtIndexPath:indexPath];
            cell.image = album.cover.image;
        }];
    }
    cell.deleteDelegate = (OCAEditableCollectionViewFlowLayout *)collectionView.collectionViewLayout;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [((AlbumCell *)cell) setAlbum:nil];
}

- (void)collectionView:(UICollectionView *)collectionView willDeleteItemAtIndexPath:(NSIndexPath *)indexPath {
    AlbumPresenter *albumPresenter = [self.albums objectAtIndex:indexPath.row];
    Album *album = [Album findFirstWithDict:@{@"spotifyUrl": albumPresenter.spotifyURL}];
    if (album) {
        [album destroy];
    }
    
    SPPlaylistContainer *playlistContainer = [[SPSession sharedSession] userPlaylists];
    [SPAsyncLoading waitUntilLoaded:playlistContainer timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
        for (SPPlaylist *playlist in playlistContainer.playlists) {
            [SPAsyncLoading waitUntilLoaded:playlist timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
                if ([playlist.name isEqualToString:[album playlistName]]) {
                    [[[SPSession sharedSession] userPlaylists] removeItem:playlist callback:^(NSError *error) {
                        NSLog(@"cool dude");
                    }];
                }
            }];
        }
    }];
    NSMutableArray *mutableAlbums = [self.albums mutableCopy];
    [mutableAlbums removeObject:albumPresenter];
    self.albums = mutableAlbums;
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath {
    AlbumPresenter *albumPresenter = [self.albums objectAtIndex:fromIndexPath.row];
    NSMutableArray *mutableAlbums = [self.albums mutableCopy];
    [mutableAlbums removeObjectAtIndex:fromIndexPath.row];
    [mutableAlbums insertObject:albumPresenter atIndex:toIndexPath.row];
    for (NSUInteger i = 0; i < [mutableAlbums count]; i++) {
        Album *anAlbum = [Album findFirstWithDict:@{@"spotifyUrl": [[mutableAlbums objectAtIndex:i] spotifyURL]}];
        anAlbum.sortOrder = @(i);
    }
    self.albums = mutableAlbums;
    [[[CoreDataHelper sharedHelper] context] save:nil];
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
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"sortOrder" ascending:YES];

        NSArray *sortedAlbums = [user.albums sortedArrayUsingDescriptors:@[sort]];
        
        NSArray *presentedAlbums = Underscore.array(sortedAlbums).map(^AlbumPresenter *(Album *album) {
            return [[AlbumPresenter alloc] initWithAlbum:album];
        }).unwrap;

//        for (Album *album in sortedAlbums) {
//            [SPAlbum albumWithAlbumURL:album.spotifyUrl inSession:[SPSession sharedSession] callback:^(SPAlbum *album) {
//                [albums addObject:album];
//                NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"sortOrder" ascending:YES];
//                if ([albums count] == [sortedAlbums count]) {
//                    [SPAsyncLoading waitUntilLoaded:albums timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
//                        self.albums = [albums sortedArrayUsingDescriptors:@[sort]];
//                        [self.albumsCollectionView reloadData];
//                    }];
//                }
//            }];
//        }
        self.albums = presentedAlbums;
        [self.albumsCollectionView reloadData];
        return;
    }
    
    SPDispatchAsync(^{
        if (self.currentSearch) {
            [self.currentSearch removeObserver:self forKeyPath:@"loaded"];
        }
        self.currentSearch = [SPSearch searchWithSearchQuery:searchText inSession:[SPSession sharedSession]];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.currentSearch addObserver:self forKeyPath:@"loaded" options:NSKeyValueObservingOptionNew context:NULL];
        self.albums = @[];
        [self.albumsCollectionView reloadData];
        self.title = searchText;
    });
}


@end
