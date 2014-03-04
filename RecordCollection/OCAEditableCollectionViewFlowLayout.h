//
//  OCAEditableCollectionViewFlowLayout.h
//  KOResume
//
//  Created by Kevin O'Mara on 8/28/13.
//  Copyright (c) 2013-2014 O'Mara Consulting Associates. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCAEditableCollectionViewFlowLayoutCell.h"

/**
 An object that adopts the OCAEditableCollectionViewDataSource protocol may optionally be notified and control movement of cells.
 */
@protocol OCAEditableCollectionViewDataSource <UICollectionViewDataSource>

@optional

/**
 Ask the delegate if the cell at indexPath can be moved.
 
 @param collectionView  the UICollectionView containing the cell.
 @param indexPath       the indexPath of the cell.
 @return                YES if the move is allowed, NO otherwise
 */
- (BOOL)collectionView: (UICollectionView *)collectionView
canMoveItemAtIndexPath: (NSIndexPath *)indexPath;

/**
 Ask the delegate if the cell at fromIndexPath can be moved to toIndexPath.
 
 @param collectionView  the UICollectionView containing the cell.
 @param fromIndexPath   the indexPath of the cell to move.
 @param toIndexPath     the indexPath where the cell will move.
 @return                YES if the move is allowed, NO otherwise
 */
- (BOOL)collectionView: (UICollectionView *)collectionView
       itemAtIndexPath: (NSIndexPath *)fromIndexPath
    canMoveToIndexPath: (NSIndexPath *)toIndexPath;

/**
 Inform the delegate the cell at indexPath is about to be moved.
 
 @param collectionView  the UICollectionView containing the cell.
 @param fromIndexPath   the indexPath of the cell to move.
 @param toIndexPath     the indexPath where the cell will move.
 */
- (void)collectionView: (UICollectionView *)collectionView
       itemAtIndexPath: (NSIndexPath *)fromIndexPath
   willMoveToIndexPath: (NSIndexPath *)toIndexPath;

/**
 Inform the delegate the cell at indexPath has moved.
 
 @param collectionView  the UICollectionView containing the cell.
 @param fromIndexPath   the indexPath of the cell to move.
 @param toIndexPath     the indexPath where the cell will move.
 */
- (void)collectionView: (UICollectionView *)collectionView
       itemAtIndexPath: (NSIndexPath *)fromIndexPath
    didMoveToIndexPath: (NSIndexPath *)toIndexPath;

/**
 Ask the delegate if the cell at indexPath can be deleted.
 
 @param collectionView  the UICollectionView containing the cell.
 @param indexPath       the indexPath of the cell.
 @return                            YES if the delete is allowed, NO otherwise
 */
- (BOOL)    collectionView: (UICollectionView *)collectionView
  canDeleteItemAtIndexPath: (NSIndexPath *)indexPath;

/**
 Inform the delegate the cell at indexPath is about to be deleted.
 
 @param collectionView  the UICollectionView containing the cell.
 @param indexPath       the indexPath of the cell about to be deleted.
 */
- (void)    collectionView: (UICollectionView *)collectionView
 willDeleteItemAtIndexPath: (NSIndexPath *)indexPath;

/**
 Inform the delegate the cell at indexPath was deleted.
 
 @param collectionView  the UICollectionView containing the cell.
 @param indexPath       the indexPath of the deleted cell.
 */
- (void)    collectionView: (UICollectionView *)collectionView
  didDeleteItemAtIndexPath: (NSIndexPath *)indexPath;

@end


/**
 An object that adopts OCAEditableCollectionViewDelegateFlowLayout will be notified of and may control the order of the cells in the collection view.
 */
@protocol OCAEditableCollectionViewDelegateFlowLayout <UICollectionViewDelegateFlowLayout>

@required

/**
 Inform the delegate editing of the layout has begun
 
 @param collectionView          the UICollectionView being edited.
 @param collectionViewLayout    the layout responsible for the editing
 */
- (void)didBeginEditingForCollectionView: (UICollectionView *)collectionView
                                  layout: (UICollectionViewLayout *)collectionViewLayout;

/**
 Inform the delegate editing of the layout has ended
 
 @param collectionView          the UICollectionView being edited.
 @param collectionViewLayout    the layout responsible for the editing
 */
- (void)didEndEditingForCollectionView: (UICollectionView *)collectionView
                                layout: (UICollectionViewLayout *)collectionViewLayout;

/**
 Inform the delegate dragging of a cell will begin
 
 @param collectionView          the UICollectionView being edited.
 @param collectionViewLayout    the layout responsible for the editing
 @param indexPath               the indexPath where the dragging will begin
 */
- (void)            collectionView: (UICollectionView *)collectionView
                            layout: (UICollectionViewLayout *)collectionViewLayout
  willBeginDraggingItemAtIndexPath: (NSIndexPath *)indexPath;

/**
 Inform the delegate dragging of a cell has begun
 
 @param collectionView          the UICollectionView being edited.
 @param collectionViewLayout    the layout responsible for the editing
 @param indexPath               the indexPath where the dragging began
 */
- (void)            collectionView: (UICollectionView *)collectionView
                            layout: (UICollectionViewLayout *)collectionViewLayout
   didBeginDraggingItemAtIndexPath: (NSIndexPath *)indexPath;

/**
 Inform the delegate dragging of a cell has ended
 
 @param collectionView          the UICollectionView being edited.
 @param collectionViewLayout    the layout responsible for the editing
 @param indexPath               the indexPath where the dragging ended
 */
- (void)            collectionView: (UICollectionView *)collectionView
                            layout: (UICollectionViewLayout *)collectionViewLayout
     didEndDraggingItemAtIndexPath: (NSIndexPath *)indexPath;

@optional

/**
 Inform the delegate dragging of a cell will end
 
 @param collectionView          the UICollectionView being edited.
 @param collectionViewLayout    the layout responsible for the editing
 @param indexPath               the indexPath where the dragging will end
 */
- (void)            collectionView: (UICollectionView *)collectionView
                            layout: (UICollectionViewLayout *)collectionViewLayout
    willEndDraggingItemAtIndexPath: (NSIndexPath *)indexPath;

/**
 Ask the delegate if editing is allowed by this collectionview and layout
 
 @param collectionView          the UICollectionView being edited.
 @param collectionViewLayout    the layout responsible for the editing
 @return indexPath              YES if editing is allowed, NO otherwise
 */
- (BOOL)shouldEnableEditingForCollectionView: (UICollectionView *)collectionView
                                      layout: (UICollectionViewLayout *)collectionViewLayout;



@end


/**
 This class adds the ability to delete and/or re-order the UICollectionViewCells in the layout.
 
 Portions created by:
 Created by Stan Chang Khin Boon on 1/10/12.
 https://github.com/lxcid/LXReorderableCollectionViewFlowLayout
 Copyright (c) 2012 d--buzz. All rights reserved.

 And:
 MobileTuts+, Akiel Khan
 http://mobile.tutsplus.com/tutorials/iphone/uicollectionview-layouts/

 In your UICollectionViewController subClass:
 
         - (void)awakeFromNib
         {
             // Allocate our custom collectionView layout
             OCAEditableCollectionViewFlowLayout *layout = [[OCAEditableCollectionViewFlowLayout alloc] init];
             // ...set some parameters to control its behavior (adjust to fit the needs of your app)
             layout.minimumInteritemSpacing  = 6;
             layout.minimumLineSpacing       = 6;
             layout.scrollDirection          = UICollectionViewScrollDirectionVertical;
             layout.sectionInset             = UIEdgeInsetsMake(5, 5, 5, 5);
             [layout setItemSize: CGSizeMake(50, 50)];
             
             // Set our layout on the collectionView
             self.collectionView.collectionViewLayout = layout;
 
             [super awakeFromNib];
         }
 
 */

@interface OCAEditableCollectionViewFlowLayout : UICollectionViewFlowLayout <UIGestureRecognizerDelegate, OCAEditableCollectionViewFlowLayoutCellDelegate>

/**
 Controls the collection view's scrolling speed
 
 Default is 300.0f
 */
@property (assign, nonatomic)           CGFloat                         scrollingSpeed;
/**
 The inset to trigger scrolling before the user's drag actually gets to the extreme edges of the screen
 
 Default is 50.0f, 50.0f, 50.0f, 50.0f,
 */
@property (assign, nonatomic)           UIEdgeInsets                    scrollingTriggerEdgeInsets;
/**
 Handles long press recognition.
 
 Exposed to allow interaction with other gesture recognizers - for example:
 
        [gestureRecognizer requireGestureRecognizerToFail: layout.longPressGestureRecognizer];
 */
@property (strong, nonatomic, readonly) UILongPressGestureRecognizer    *longPressGestureRecognizer;
/**
 Handles pan recognition.
 
 Exposed to allow interaction with other gesture recognizers - for example:
 
        [gestureRecognizer requireGestureRecognizerToFail: layout.panGestureRecognizer];
 */
@property (strong, nonatomic, readonly) UIPanGestureRecognizer          *panGestureRecognizer;
/**
 Handles tap recognition.
 
 Exposed to allow interaction with other gesture recognizers - for example:

        [gestureRecognizer requireGestureRecognizerToFail: layout.tapGestureRecognizer];
 */
@property (strong, nonatomic, readonly) UITapGestureRecognizer          *tapGestureRecognizer;

@property (assign, nonatomic, getter = isEditModeOn) BOOL  editModeOn;
@property (assign, nonatomic, readonly) id<OCAEditableCollectionViewDelegateFlowLayout>  delegate;


@end

