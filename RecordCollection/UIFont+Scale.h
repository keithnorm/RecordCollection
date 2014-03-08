//
//  UIFont+Scale.h
//  RecordCollection
//
//  Created by Keith Norman on 3/7/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (Scale)
+ (UIFont *)preferredFontForTextStyle:(NSString *)style scale:(CGFloat)scaleFactor;
@end
