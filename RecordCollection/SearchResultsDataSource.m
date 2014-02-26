//
//  SearchResultsDataSource.m
//  RecordCollection
//
//  Created by Keith Norman on 2/24/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import "SearchResultsDataSource.h"
#import <CocoaLibSpotify/CocoaLibSpotify.h>

@interface SearchResultsDataSource()

@end

@implementation SearchResultsDataSource

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuse = @"SearchResultsCell";
    SPArtist *searchResultArtist = [self.searchResults objectAtIndex:indexPath.row];
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    cell.textLabel.text = searchResultArtist.name;
    return cell;
}

@end
