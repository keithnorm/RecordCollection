//
//  Created by merowing2 on 3/25/12.
//
//
//
#import <Foundation/Foundation.h>
#import "SFObservers.h"

@interface NSObject (SFObservers)

- (void)sf_addObserver:(id)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)aContext;
- (void)sf_removeObserver:(id)observer forKeyPath:(NSString *)keyPath;
@end