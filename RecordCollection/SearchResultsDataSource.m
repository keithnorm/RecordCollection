//
//  SearchResultsDataSource.m
//  RecordCollection
//
//  Created by Keith Norman on 2/24/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import "SearchResultsDataSource.h"
#import <FormatterKit/TTTArrayFormatter.h>
#import <CocoaLibSpotify/CocoaLibSpotify.h>

@interface SearchResultsDataSource()

@end

@implementation SearchResultsDataSource

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.searchResults.artists count] ? 3 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger rowCount = 0;
    switch (section) {
        case 0:
            rowCount = [self.searchResults.artists count];
            break;
        case 1:
            rowCount = [self.searchResults.tracks count];
            break;
        case 2:
            rowCount = [self.searchResults.albums count];
            break;
        default:
            break;
    }
    return rowCount;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [@[@"Artists", @"Tracks", @"Albums"] objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuse = @"SearchResultsCell";
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuse];
    }
    id searchResultItem;
    switch (indexPath.section) {
        case 0:
            searchResultItem = [self.searchResults.artists objectAtIndex:indexPath.row];
            cell.detailTextLabel.text = nil;
            break;
            
        case 1: {
            searchResultItem = [self.searchResults.tracks objectAtIndex:indexPath.row];
            NSArray *artists = [[((SPTrack *)searchResultItem) artists] valueForKey:@"name"];
            cell.detailTextLabel.text = [TTTArrayFormatter localizedStringFromArray:artists arrayStyle:TTTArrayFormatterSentenceStyle];
            break;
        }
        
        case 2:
            searchResultItem = [self.searchResults.albums objectAtIndex:indexPath.row];
            cell.detailTextLabel.text = nil;
            
        default:
            break;
    }
    cell.textLabel.text = [searchResultItem name];
    return cell;
}

@end
