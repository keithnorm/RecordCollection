//
//  MenuViewController.m
//  RecordCollection
//
//  Created by Keith Norman on 2/23/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import "MenuViewController.h"
#import "SearchResultsDataSource.h"
#import "SearchResultsDelegate.h"
#import "UIView+Event.h"
#import "MenuItem.h"
#import "UIView+StyleClass.h"
#import <CocoaLibSpotify/CocoaLibSpotify.h>

@interface MenuViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *searchResultsTableView;

@property (nonatomic, strong) SPSearch *currentSearch;
@property (nonatomic, strong) NSArray *searchResults;
@property (nonatomic, strong) NSDictionary *navigationItems;
@property (nonatomic, strong) SearchResultsDataSource *searchDataSource;
@property (nonatomic, strong) SearchResultsDelegate *searchDelegate;


@end

@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.searchDataSource = [[SearchResultsDataSource alloc] init];
    self.searchDelegate = [[SearchResultsDelegate alloc] init];
    CGRect searchResultsFrame = CGRectOffset(self.view.bounds, 0, 44);
    searchResultsFrame.size.height = searchResultsFrame.size.height - 44;
    self.searchResultsTableView = [[UITableView alloc] initWithFrame:searchResultsFrame style:UITableViewStylePlain];
    self.searchResultsTableView.hidden = YES;
    [self.view addSubview:self.searchResultsTableView];
    self.searchResults = @[];
    self.navigationItems = @{@"My Stuff": @[@"My Collection", @"Recently Played"]};
    self.searchResultsTableView.dataSource = self.searchDataSource;
    self.searchResultsTableView.delegate = self.searchDelegate;
    self.searchBar.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.searchResultsTableView.hidden = YES;
    self.searchBar.text = @"";
}

#pragma mark UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchResultsTableView.hidden = NO;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchBar.text.length > 3) {
        if (self.currentSearch) {
            self.currentSearch = nil;
        }
        self.currentSearch = [SPSearch liveSearchWithSearchQuery:searchBar.text inSession:[SPSession sharedSession]];
        __weak MenuViewController *weakSelf = self;
        [SPAsyncLoading waitUntilLoaded:self.currentSearch timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *loadedItems, NSArray *notLoadedItems) {
            if (loadedItems.count > 0) {
//                [self searchDidFinish:loadedItems[0]];
                weakSelf.searchDataSource.searchResults = weakSelf.currentSearch;
                weakSelf.searchResultsTableView.hidden = NO;
                [weakSelf.searchResultsTableView reloadData];
            }
            else {
             }
        }];
    }
}

- (void)dealloc {
    [self.currentSearch removeObserver:self forKeyPath:@"loaded"];
}

#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"loaded"] && [object isKindOfClass:[SPSearch class]]) {
//        self.searchDataSource.searchResults = self.currentSearch.artists;
        self.searchResultsTableView.hidden = NO;
        [self.searchResultsTableView reloadData];
    }
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.navigationItems allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.navigationItems objectForKey:[[self.navigationItems allKeys] objectAtIndex:section]] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self.navigationItems allKeys] objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuse = @"NavigationCell";
    NSString *navItem = [[self.navigationItems objectForKey:[[self.navigationItems allKeys] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    MenuItem *menuItem = [[MenuItem alloc] initWithFrame:cell.bounds];
    if ([navItem isEqualToString:@"My Collection"]) {
        menuItem.styleClass = @"myCollectionLink";
    } else if ([navItem isEqualToString:@"Recently Played"]) {
        menuItem.styleClass = @"recentlyPlayedLink";
    }
    [cell.contentView addSubview:menuItem];
    menuItem.text = navItem;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSArray *navItems = @[@"My Collection", @"Recently Played"];
    NSString *navItem = [navItems objectAtIndex:indexPath.row];
    cell.selected = NO;
    [tableView fireEvent:@"performSearch" withObject:navItem];
}
@end
