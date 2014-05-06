//
//  ASHSpringyCollectionViewFlowLayout.m
//  ASHSpringyCollectionView
//
//  Created by Ash Furrow on 2013-08-12.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

/*
 
 This implementation is based on https://github.com/TeehanLax/UICollectionView-Spring-Demo
 which I developed at Teehan+Lax. Check it out.
 
 */

#import "MYSSpringyCollectionViewFlowLayout.h"


@interface MYSSpringyCollectionViewFlowLayout ()
@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;
@property (nonatomic, strong) NSMutableSet      *visibleIndexPathsSet;
@property (nonatomic, assign) CGFloat           latestDelta;
@property (nonatomic, assign) NSUInteger        itemCount;
@property (nonatomic, strong) NSMutableSet      *updatingItemIndexPaths;
@end


@implementation MYSSpringyCollectionViewFlowLayout

- (void)commonInit
{
    self.minimumInteritemSpacing    = 0;
    self.minimumLineSpacing         = 5;
    self.dynamicAnimator            = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
    self.visibleIndexPathsSet       = [NSMutableSet new];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];

    // Need to overflow our actual visible rect slightly to avoid flickering.
    CGSize contentSize = self.collectionView.contentSize;
    NSArray *items = [super layoutAttributesForElementsInRect:
                      CGRectMake(0.0f, 0.0f, contentSize.width, contentSize.height)];

    if ([items count] != [self.dynamicAnimator.behaviors count]) {
        [self.dynamicAnimator removeAllBehaviors];
        CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
        [items enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *item, NSUInteger idx, BOOL *stop) {
            CGPoint center = item.center;
            UIAttachmentBehavior *springBehaviour = [[UIAttachmentBehavior alloc] initWithItem:item attachedToAnchor:center];

            springBehaviour.length      = 0.0f;
            springBehaviour.damping     = 0.7f;
            springBehaviour.frequency   = 0.7f;

            // If our touchLocation is not (0,0), we'll need to adjust our item's center "in flight"
            if (!CGPointEqualToPoint(CGPointZero, touchLocation)) {
                CGFloat yDistanceFromTouch = fabsf(touchLocation.y - springBehaviour.anchorPoint.y);
                CGFloat scrollResistance = yDistanceFromTouch / 1000.0f;

                if (self.latestDelta < 0) {
                    center.y += MAX(self.latestDelta, self.latestDelta * scrollResistance);
                }
                else {
                    center.y += MIN(self.latestDelta, self.latestDelta * scrollResistance);
                }
                item.center = center;
            }

            [self.dynamicAnimator addBehavior:springBehaviour];
            [self.visibleIndexPathsSet addObject:item.indexPath];
        }];
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [self.dynamicAnimator itemsInRect:rect];
}

//- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [self.dynamicAnimator layoutAttributesForCellAtIndexPath:indexPath];
//}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    UIScrollView *scrollView = self.collectionView;
    CGFloat delta = newBounds.origin.y - scrollView.bounds.origin.y;
    
    self.latestDelta = delta;
    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
    
    [self.dynamicAnimator.behaviors enumerateObjectsUsingBlock:^(UIAttachmentBehavior *springBehaviour, NSUInteger idx, BOOL *stop) {
        CGFloat yDistanceFromTouch = fabsf(touchLocation.y - springBehaviour.anchorPoint.y);
        CGFloat scrollResistance = yDistanceFromTouch / 1000.0f;
        
        UICollectionViewLayoutAttributes *item = [springBehaviour.items firstObject];
        CGPoint center = item.center;
        if (delta < 0) {
            center.y += MAX(delta, delta * scrollResistance);
        }
        else {
            center.y += MIN(delta, delta * scrollResistance);
        }
        item.center = center;

        [self.dynamicAnimator updateItemUsingCurrentState:item];
    }];
    
    return NO;
}

-(void)prepareForCollectionViewUpdates:(NSArray *)updateItems
{
    [super prepareForCollectionViewUpdates:updateItems];

    self.updatingItemIndexPaths = [NSMutableSet new];
    [updateItems enumerateObjectsUsingBlock:^(UICollectionViewUpdateItem *updateItem, NSUInteger idx, BOOL *stop) {
        if (updateItem.updateAction == UICollectionUpdateActionInsert) {
            [self.updatingItemIndexPaths addObject:updateItem.indexPathAfterUpdate];
        }
        else if (updateItem.updateAction == UICollectionUpdateActionDelete) {
            [self.updatingItemIndexPaths addObject:updateItem.indexPathBeforeUpdate];
        }
    }];
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    if ([self.updatingItemIndexPaths member:itemIndexPath]) {
        NSIndexPath *previousIndexPath = [NSIndexPath indexPathForItem:(itemIndexPath.item > 0 ? itemIndexPath.item - 1 : itemIndexPath.item)
                                                             inSection:itemIndexPath.section];
        UICollectionViewLayoutAttributes *attributes = [[self layoutAttributesForItemAtIndexPath:previousIndexPath] copy];
        attributes.alpha = 0;
        return attributes;
    }
    else {
        return [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    }
}
//
//- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
//{
//    if ([self.updatingItemIndexPaths member:itemIndexPath]) {
//        UICollectionViewLayoutAttributes *attributes = [[self layoutAttributesForItemAtIndexPath:itemIndexPath] copy];
//        attributes.alpha = 0;
//        return attributes;
//    }
//    else {
//        return [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
//    }
//}

@end
