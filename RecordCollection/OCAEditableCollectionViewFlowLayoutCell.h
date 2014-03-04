//
//  OCAEditableCollectionViewFlowLayoutCell.h
//  KOResume
//
//  Created by Kevin O'Mara on 10/28/13.
//  Copyright (c) 2013-2014 O'Mara Consulting Associates. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OCAEditableCellDeleteButton : UIButton

@property (nonatomic, strong) UIColor *backgroundColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *strokeColor UI_APPEARANCE_SELECTOR;


@end

/**
 An object that adopts the OCACollectionViewFlowLayoutCellDelegate protocol must support delete operations
 */
@protocol OCAEditableCollectionViewFlowLayoutCellDelegate

@required

/**
 This method will be invoked on the deleteDelegate when the user presses the delete button
 
 @param cell    the cell to delete.
 */
- (void)deleteCell:(UICollectionViewCell *)cell;

@end

/**
 This class supports deletable collection view cells
 */
@interface OCAEditableCollectionViewFlowLayoutCell : UICollectionViewCell

/**
 The IBOutlet for the delete button
 */
@property (nonatomic, strong)   IBOutlet OCAEditableCellDeleteButton   *deleteButton;

/**
 The delegate to call when the delete button is pressed
 */
@property (nonatomic, strong)   UICollectionViewFlowLayout<OCAEditableCollectionViewFlowLayoutCellDelegate>   *deleteDelegate;

@end
