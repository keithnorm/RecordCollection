//
//  NSManagedObject+Helper.m
//  RecordCollection
//
//  Created by Keith Norman on 2/23/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import "NSManagedObject+Helper.h"
#import "CoreDataHelper.h"

@implementation NSManagedObject (Helper)

+ (instancetype)new {
    NSManagedObject *object;
    NSManagedObjectContext *context = [[CoreDataHelper sharedHelper] context];
    NSEntityDescription *description = [self.class entityDescriptionInContext:context];
    object = [NSEntityDescription insertNewObjectForEntityForName:description.name inManagedObjectContext:context];
    return object;
}

+ (NSArray *)all {
    NSManagedObjectContext *context = [[CoreDataHelper sharedHelper] context];
    NSEntityDescription *entity = [self entityDescriptionInContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = entity;
    NSError *error = nil;
    return [context executeFetchRequest:request error:&error];
}

+ (instancetype)first {
    NSManagedObjectContext *context = [[CoreDataHelper sharedHelper] context];
    NSEntityDescription *entity = [self entityDescriptionInContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = entity;
    NSError *error = nil;
    request.fetchLimit = 1;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    return objects.count > 0 ? [objects objectAtIndex:0] : nil;
}

+(NSEntityDescription *)entityDescriptionInContext:(NSManagedObjectContext *)context {
    NSEntityDescription *entityDescription;
    if ([self respondsToSelector:NSSelectorFromString(@"entityInManagedObjectContext:")]) {
        NSMethodSignature *sig = [self methodSignatureForSelector:NSSelectorFromString(@"entityInManagedObjectContext:")];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
        invocation.target = self;
        invocation.selector = NSSelectorFromString(@"entityInManagedObjectContext:");
        [invocation getReturnValue:&entityDescription];
    } else {
        entityDescription = [NSEntityDescription entityForName:NSStringFromClass(self) inManagedObjectContext:context];
    }
    return entityDescription;
}

+ (NSFetchRequest *)fetchRequestWithPredicateFromDict:(NSDictionary *)conditions {
    NSEntityDescription *entityDescription = [self entityDescriptionInContext:[[CoreDataHelper sharedHelper] context]];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSMutableArray *subPredicates = [NSMutableArray array];
    [conditions enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
        [subPredicates addObject:[NSPredicate predicateWithFormat:@"%K = %@", key, value]];
    }];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:subPredicates];
    request.predicate = predicate;
    return request;
}

+ (NSArray *)findWithDict:(NSDictionary *)conditions {
    NSFetchRequest *request = [self fetchRequestWithPredicateFromDict:conditions];
    NSError *error = nil;
    NSArray *fetchedObjects = [[[CoreDataHelper sharedHelper] context] executeFetchRequest:request error:&error];
    return fetchedObjects;
}

+ (instancetype)findFirstWithDict:(NSDictionary *)conditions {
    NSFetchRequest *request = [self fetchRequestWithPredicateFromDict:conditions];
    request.fetchLimit = 1;
    NSError *error = nil;
    NSArray *fetchedObjects = [[[CoreDataHelper sharedHelper] context] executeFetchRequest:request error:&error];
    return [fetchedObjects count] ? [fetchedObjects objectAtIndex:0] : nil;
}

- (void)destroy {
    [self.managedObjectContext deleteObject:self];
}

@end
