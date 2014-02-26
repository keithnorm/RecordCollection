//
//  CoreDataHelper.h
//  Grocery Dude
//
//  Created by Tim Roadley on 18/09/13.
//  Copyright (c) 2013 Tim Roadley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataHelper :NSObject

@property (nonatomic, readonly) NSManagedObjectContext       *context;
@property (nonatomic, readonly) NSManagedObjectModel         *model;
@property (nonatomic, readonly) NSPersistentStoreCoordinator *coordinator;
@property (nonatomic, readonly) NSPersistentStore            *store;

+ (instancetype)sharedHelper;
- (void)setupCoreData;
- (void)saveContext;
@end
