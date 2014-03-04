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
        case RCSearchTableSectionAlbums:
            [tableView fireEvent:@"performSearch" withObject:searchText];
            break;
        case RCSearchTableSectionTracks:
            [tableView fireEvent:@"selectTrackFromSearchResults" withObject:[dataSource.searchResults.tracks objectAtIndex:indexPath.row]];
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

@end
