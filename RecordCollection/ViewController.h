//
//  ViewController.h
//  RecordCollection
//
//  Created by Keith Norman on 2/23/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, strong) NSString *searchText;
@property (nonatomic, strong) NSArray *albums;

// Outlets!
@property (nonatomic, weak) IBOutlet UICollectionView *albumsCollectionView;

@end
