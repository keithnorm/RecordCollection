//
//  UIImage+Gradient.h
//  RecordCollection
//
//  Created by Keith Norman on 2/25/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Gradient)

+ (instancetype)gradientWithColors:(NSArray *)colors height:(CGFloat)height;
@end
