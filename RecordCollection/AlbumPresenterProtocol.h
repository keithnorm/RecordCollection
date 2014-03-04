//
//  AlbumPresenterProtocol.h
//  RecordCollection
//
//  Created by Keith Norman on 3/3/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ArtistPresenterProtocol <NSObject>

@property (nonatomic, strong) NSString *name;

@end

@protocol CoverImagePresenterProtocol <NSObject>

@property (nonatomic, strong) UIImage *image;

@end

@protocol AlbumPresenterProtocol <NSObject>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSURL *spotifyURL;
@property (nonatomic, strong) id<ArtistPresenterProtocol> artist;
@property (nonatomic, strong) id<CoverImagePresenterProtocol> cover;

@end
