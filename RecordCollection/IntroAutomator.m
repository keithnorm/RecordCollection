//
//  IntroAutomator.m
//  RecordCollection
//
//  Created by Keith Norman on 3/6/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import "IntroAutomator.h"
#import "NSTimer+Blocks.h"
#import "SearchResultsDataSource.h"
#import "UIView+Event.h"
#import <CocoaLibSpotify/CocoaLibSpotify.h>

@implementation IntroAutomator

- (id)initWithDrawer:(ICSDrawerController *)drawer list:(ViewController *)listController menu:(MenuViewController<UISearchBarDelegate> *)menu {
    self = [super init];
    if (self) {
        _drawer = drawer;
        _menu = menu;
        _listController = listController;
    }
    return self;
}

- (void)start {
   // open drawer
   // search for something
   // click first result
   // click +
   // go back to collection
    
    [self.drawer open];
    [NSTimer scheduledTimerWithTimeInterval:1.0f block:^{
        self.menu.searchBar.text = @"Walk Off the Earth";
        [self.menu searchBar:self.menu.searchBar textDidChange:@"Walk Off the Earth"];
        [self.menu.searchDataSource addObserver:self forKeyPath:@"searchResults" options:NSKeyValueObservingOptionNew context:NULL];
    } repeats:NO];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"searchResults"]) {
        [NSTimer scheduledTimerWithTimeInterval:0.5f block:^{
            [(id<UITableViewDelegate>)self.menu.searchDelegate tableView:self.menu.searchResultsTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            
            [self.listController addObserver:self forKeyPath:@"albums" options:NSKeyValueObservingOptionNew context:NULL];
            
        } repeats:NO];
    } else if ([keyPath isEqualToString:@"albums"]) {
        if ([self.listController.albums count]) {
            [NSTimer scheduledTimerWithTimeInterval:0.5f block:^{
                UICollectionViewCell *cell = [[self.listController albumsCollectionView] cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                [self.listController performSegueWithIdentifier:@"albumDetails" sender:cell];
                SPAlbum *album = [self.listController.albums objectAtIndex:0];
                [NSTimer scheduledTimerWithTimeInterval:0.5f block:^{
                    [self.listController.view fireEvent:@"didAddAlbumToCollection" withObject:album];
                    
                    [NSTimer scheduledTimerWithTimeInterval:2.0f block:^{
                        [self.listController.navigationController popToRootViewControllerAnimated:YES];
                        [self.drawer.view fireEvent:@"performSearch" withObject:@"My Collection"];
                        [self.listController removeObserver:self forKeyPath:@"albums"];
                    } repeats:NO];
                    
                } repeats:NO];
                
            } repeats:NO];
        }
    }
}
@end
