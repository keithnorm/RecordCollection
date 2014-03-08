//
//  SearchResultsDelegate.m
//  RecordCollection
//
//  Created by Keith Norman on 2/24/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import "SearchResultsDelegate.h"
#import "SearchResultsDataSource.h"
#import "UIView+Event.h"

NS_ENUM(NSUInteger, RCSearchTableSection) {
    RCSearchTableSectionArtists,
    RCSearchTableSectionTracks,
    RCSearchTableSectionAlbums
};

@implementation SearchResultsDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *searchText = [[[tableView cellForRowAtIndexPath:indexPath] textLabel] text];
    SearchResultsDataSource *dataSource = (SearchResultsDataSource *)tableView.dataSource;
    switch (indexPath.section) {
        case RCSearchTableSectionArtists:
            if ([dataSource.searchResults.artists count]) {
                [tableView fireEvent:@"performSearch" withObject:searchText];
            } else if ([dataSource.searchResults.tracks count]) {
                [tableView fireEvent:@"selectTrackFromSearchResults" withObject:[dataSource.searchResults.tracks objectAtIndex:indexPath.row]];
            } else {
                [tableView fireEvent:@"performSearch" withObject:searchText];
            }
            break;
        case RCSearchTableSectionTracks:
            if ([dataSource.searchResults.tracks count]) {
                [tableView fireEvent:@"selectTrackFromSearchResults" withObject:[dataSource.searchResults.tracks objectAtIndex:indexPath.row]];
            } else {
                [tableView fireEvent:@"performSearch" withObject:searchText];
            }
            break;
        case RCSearchTableSectionAlbums:
            [tableView fireEvent:@"performSearch" withObject:searchText];
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

@end
