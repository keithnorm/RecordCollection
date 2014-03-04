//
//  OCAEditableLayoutAttributes.h
//  KOResume
//
//  Created by Kevin O'Mara on 8/31/13.
//  Copyright (c) 2013-2014 O'Mara Consulting Associates. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 This class adds properties to the layout to support editing collection views
 */
@interface OCAEditableLayoutAttributes : UICollectionViewLayoutAttributes

/**
 Controls whether the cell's delete button should be shown or hidden.
 */
@property (assign, nonatomic, getter = isDeleteButtonHidden) BOOL deleteButtonHidden;

@end
