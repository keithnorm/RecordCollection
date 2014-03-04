//
//  SearchResultsDataSource.h
//  RecordCollection
//
//  Created by Keith Norman on 2/24/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaLibSpotify/CocoaLibSpotify.h>

@interface SearchResultsDataSource : NSObject<UITableViewDataSource>

@property (nonatomic, strong) SPSearch *searchResults;

@end
