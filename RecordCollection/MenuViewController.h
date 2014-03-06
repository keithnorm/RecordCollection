//
//  MenuViewController.h
//  RecordCollection
//
//  Created by Keith Norman on 2/23/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchResultsDataSource.h"
#import "SearchResultsDelegate.h"

@interface MenuViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITableView *navigationTable;
@property (nonatomic, strong) UITableView *searchResultsTableView;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) SearchResultsDataSource *searchDataSource;
@property (nonatomic, strong) SearchResultsDelegate *searchDelegate;

@end
