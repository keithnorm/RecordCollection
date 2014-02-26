//
//  SearchResultsDelegate.m
//  RecordCollection
//
//  Created by Keith Norman on 2/24/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import "SearchResultsDelegate.h"
#import "UIView+Event.h"

@implementation SearchResultsDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *searchText = [[[tableView cellForRowAtIndexPath:indexPath] textLabel] text];
    [tableView fireEvent:@"performSearch" withObject:searchText];
}

@end
