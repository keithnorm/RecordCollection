//
//  Album.h
//  RecordCollection
//
//  Created by Keith Norman on 3/3/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Album : NSManagedObject

@property (nonatomic, retain) NSString * artistName;
@property (nonatomic, retain) id cover;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * sortOrder;
@property (nonatomic, retain) id spotifyUrl;
@property (nonatomic, retain) NSNumber * tracksCount;
@property (nonatomic, retain) User *user;

@end
