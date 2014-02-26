//
//  NSManagedObject+Helper.h
//  RecordCollection
//
//  Created by Keith Norman on 2/23/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Helper)

+ (NSArray *)all;
+ (instancetype)new;
+ (instancetype)first;
+ (NSArray *)findWithDict:(NSDictionary *)conditions;
+ (instancetype)findFirstWithDict:(NSDictionary *)conditions;

@end
