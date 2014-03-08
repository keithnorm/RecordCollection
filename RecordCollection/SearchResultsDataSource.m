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
    NSUInteger numSections = 0;
    if ([self.searchResults.artists count]) {
        numSections++;
    }
    if ([self.searchResults.tracks count]) {
        numSections++;
    }
    
    if ([self.searchResults.albums count]) {
        numSections++;
    }
    return numSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger rowCount = 0;
    switch (section) {
        case 0:
            if ([self.searchResults.artists count]) {
                rowCount = [self.searchResults.artists count];
            } else if ([self.searchResults.tracks count]) {
                rowCount = [self.searchResults.tracks count];
            } else {
                rowCount = [self.searchResults.albums count];
            }
            break;
        case 1:
            if ([self.searchResults.tracks count]) {
                rowCount = [self.searchResults.tracks count];
            } else if ([self.searchResults.albums count]) {
                rowCount = [self.searchResults.albums count];
            }
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
    NSMutableArray *sectionTitles = [NSMutableArray array];
    if ([self.searchResults.artists count]) {
        [sectionTitles addObject:@"Artists"];
    }
    if ([self.searchResults.tracks count]) {
        [sectionTitles addObject:@"Tracks"];
    }
    if ([self.searchResults.albums count]) {
        [sectionTitles addObject:@"Albums"];
    }
    return [sectionTitles objectAtIndex:section];
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
            if ([self.searchResults.artists count]) {
                searchResultItem = [self.searchResults.artists objectAtIndex:indexPath.row];
                cell.detailTextLabel.text = nil;
            } else if ([self.searchResults.tracks count]) {
                searchResultItem = [self.searchResults.tracks objectAtIndex:indexPath.row];
                searchResultItem = [self.searchResults.tracks objectAtIndex:indexPath.row];
                NSArray *artists = [[((SPTrack *)searchResultItem) artists] valueForKey:@"name"];
                cell.detailTextLabel.text = [TTTArrayFormatter localizedStringFromArray:artists arrayStyle:TTTArrayFormatterSentenceStyle];
            } else {
                searchResultItem = [self.searchResults.albums objectAtIndex:indexPath.row];
                cell.detailTextLabel.text = nil;
            }
            break;
            
        case 1: {
            if ([self.searchResults.tracks count]) {
                searchResultItem = [self.searchResults.tracks objectAtIndex:indexPath.row];
                NSArray *artists = [[((SPTrack *)searchResultItem) artists] valueForKey:@"name"];
                cell.detailTextLabel.text = [TTTArrayFormatter localizedStringFromArray:artists arrayStyle:TTTArrayFormatterSentenceStyle];
            } else if ([self.searchResults.albums count]) {
                searchResultItem = [self.searchResults.albums objectAtIndex:indexPath.row];
                cell.detailTextLabel.text = nil;
            }
            
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
