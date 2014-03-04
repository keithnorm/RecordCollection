//
//  UIImageToNSDataTransformer.m
//  RecordCollection
//
//  Created by Keith Norman on 3/3/14.
//  Copyright (c) 2014 Keith Norman. All rights reserved.
//

#import "UIImageToNSDataTransformer.h"

@implementation UIImageToNSDataTransformer

+(Class)transformedValueClass {
    return [NSData class];
}

+(BOOL) allowsReverseTransformation {
    return YES;
}

-(id)transformedValue:(id) value {
    return UIImagePNGRepresentation(value);
}

-(id)reverseTransformedValue:(id) value {
    return [[UIImage alloc] initWithData:value];
}

@end
