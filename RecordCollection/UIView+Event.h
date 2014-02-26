//
//  UIView+Event.h
//  RecordCollection
//
//  Created by Keith Norman on 2/24/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Event)

- (void)fireEvent:(NSString *)eventName withObject:(id)obj;

@end
